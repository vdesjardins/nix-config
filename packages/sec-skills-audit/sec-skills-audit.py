#!/usr/bin/env python3
"""
sec-skills-audit - Security auditor for OpenCode skill files

Scans ~/.config/opencode/skill for:
- Hidden text patterns (HTML comments, <details>, CSS hiding, zero-width chars, bidi controls)
- Shell script vulnerabilities (unquoted vars, eval, command injection, destructive ops)
"""

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass, field
from enum import Enum
from pathlib import Path
from typing import List, Dict, Any


class Severity(Enum):
    """Issue severity levels"""
    CLEAN = 0
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    CRITICAL = 4


@dataclass
class Finding:
    """Security or hidden-text finding"""
    file_path: str
    issue_type: str
    severity: Severity
    line_number: int
    description: str
    snippet: str = ""


@dataclass
class ScanResult:
    """Aggregate scan results"""
    files_scanned: int = 0
    findings: List[Finding] = field(default_factory=list)
    clean_files: List[str] = field(default_factory=list)

    def max_severity(self) -> Severity:
        """Return highest severity found"""
        if not self.findings:
            return Severity.CLEAN
        return max((f.severity for f in self.findings), key=lambda s: s.value)


class HiddenTextScanner:
    """Detects hidden content in files"""

    # Zero-width and bidi control characters
    ZERO_WIDTH_CHARS = [
        '\u200B',  # ZWSP
        '\u200C',  # ZWNJ
        '\u200D',  # ZWJ
        '\uFEFF',  # BOM
    ]
    BIDI_CHARS = [
        '\u202A', '\u202B', '\u202C', '\u202D', '\u202E',  # LRE, RLE, PDF, LRO, RLO
        '\u2066', '\u2067', '\u2068', '\u2069',  # LRI, RLI, FSI, PDI
    ]

    HTML_PATTERNS = [
        (r'<!--.*?-->', 'HTML comment'),
        (r'<details>', 'Collapsible details tag'),
        (r'<summary>', 'Summary tag'),
        (r'style=["\'].*?(display:\s*none|visibility:\s*hidden)', 'Hidden CSS'),
        (r'<\w+[^>]*\bhidden\b', 'Hidden attribute'),
        (r'<script[^>]*>.*?</script>', 'Script tag'),
    ]

    def scan_file(self, file_path: Path) -> List[Finding]:
        """Scan single file for hidden text"""
        findings = []
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                lines = content.splitlines()

            # Check HTML patterns
            for pattern, issue_type in self.HTML_PATTERNS:
                for match in re.finditer(pattern, content, re.IGNORECASE | re.DOTALL):
                    line_num = content[:match.start()].count('\n') + 1
                    snippet = match.group(0)[:100]
                    findings.append(Finding(
                        file_path=str(file_path),
                        issue_type=issue_type,
                        severity=Severity.LOW,
                        line_number=line_num,
                        description=f"Found {issue_type}",
                        snippet=snippet
                    ))

            # Check zero-width and bidi characters
            for line_num, line in enumerate(lines, start=1):
                for char in self.ZERO_WIDTH_CHARS:
                    if char in line:
                        findings.append(Finding(
                            file_path=str(file_path),
                            issue_type="Zero-width character",
                            severity=Severity.MEDIUM,
                            line_number=line_num,
                            description=f"Found zero-width character: U+{ord(char):04X}",
                            snippet=line[:100]
                        ))

                for char in self.BIDI_CHARS:
                    if char in line:
                        findings.append(Finding(
                            file_path=str(file_path),
                            issue_type="Bidi control character",
                            severity=Severity.HIGH,
                            line_number=line_num,
                            description=f"Found bidi control: U+{ord(char):04X}",
                            snippet=line[:100]
                        ))

        except Exception as e:
            findings.append(Finding(
                file_path=str(file_path),
                issue_type="Scan error",
                severity=Severity.LOW,
                line_number=0,
                description=f"Failed to scan: {e}"
            ))

        return findings


class ShellSecurityScanner:
    """Detects security issues in shell scripts"""

    SECURITY_PATTERNS = [
        (r'\$\w+(?!\s*[="])', Severity.MEDIUM, "Unquoted variable expansion"),
        (r'\beval\s+', Severity.HIGH, "eval usage (injection risk)"),
        (r'\bexec\s+', Severity.MEDIUM, "exec usage"),
        (r'rm\s+-rf?\s+[^"\']*\$', Severity.HIGH, "Destructive rm with unquoted var"),
        (r'curl\s+.*\|\s*(bash|sh)', Severity.CRITICAL, "curl | bash pattern"),
        (r'wget\s+.*\|\s*(bash|sh)', Severity.CRITICAL, "wget | sh pattern"),
        (r'(API_KEY|TOKEN|PASSWORD|SECRET)\s*=\s*["\']?\w{10,}', Severity.CRITICAL, "Hardcoded secret"),
    ]

    def scan_file(self, file_path: Path) -> List[Finding]:
        """Scan shell script for security issues"""
        findings = []
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()

            for line_num, line in enumerate(lines, start=1):
                # Skip comments
                if line.strip().startswith('#'):
                    continue

                for pattern, severity, description in self.SECURITY_PATTERNS:
                    if re.search(pattern, line, re.IGNORECASE):
                        findings.append(Finding(
                            file_path=str(file_path),
                            issue_type="Shell security issue",
                            severity=severity,
                            line_number=line_num,
                            description=description,
                            snippet=line.strip()[:100]
                        ))

        except Exception as e:
            findings.append(Finding(
                file_path=str(file_path),
                issue_type="Scan error",
                severity=Severity.LOW,
                line_number=0,
                description=f"Failed to scan: {e}"
            ))

        return findings


class FileType(Enum):
    """File type categories for filtering"""
    ALL = "all"
    MARKDOWN = "markdown"
    SCRIPT = "script"


class SkillAuditor:
    """Main audit orchestrator"""

    SHELL_EXTENSIONS = {'.sh', '.bash', '.zsh', '.py', '.js', '.ts', '.rb', '.pl', '.ps1'}
    MARKDOWN_EXTENSIONS = {'.md', '.markdown', '.rst', '.txt'}

    def __init__(self, base_path: Path, file_types: List[FileType] | None = None):
        self.base_path = base_path.expanduser()
        self.file_types = file_types if file_types else [FileType.ALL]
        self.hidden_scanner = HiddenTextScanner()
        self.shell_scanner = ShellSecurityScanner()

    def discover_files(self) -> List[Path]:
        """Find all files, following symlinks"""
        files = []
        for root, dirs, filenames in os.walk(self.base_path, followlinks=True):
            for filename in filenames:
                file_path = Path(root) / filename
                # Avoid infinite loops from circular symlinks
                try:
                    file_path.resolve(strict=True)
                    files.append(file_path)
                except (OSError, RuntimeError):
                    continue
        return files

    def should_scan_file(self, file_path: Path) -> tuple[bool, bool]:
        """
        Determine if file should be scanned for hidden text and/or security issues.
        Returns: (scan_hidden_text, scan_security)
        """
        suffix = file_path.suffix.lower()

        # ALL scans everything
        if FileType.ALL in self.file_types:
            return (True, suffix in self.SHELL_EXTENSIONS)

        scan_hidden = False
        scan_security = False

        # Check markdown filter
        if FileType.MARKDOWN in self.file_types:
            if suffix in self.MARKDOWN_EXTENSIONS:
                scan_hidden = True

        # Check script filter
        if FileType.SCRIPT in self.file_types:
            if suffix in self.SHELL_EXTENSIONS:
                scan_hidden = True
                scan_security = True

        return (scan_hidden, scan_security)

    def scan_all(self, severity_filter: Severity = Severity.CLEAN) -> ScanResult:
        """Run full audit"""
        result = ScanResult()
        files = self.discover_files()

        for file_path in files:
            file_findings = []

            # Determine what to scan based on file type filter
            scan_hidden, scan_security = self.should_scan_file(file_path)

            # Skip if file doesn't match any filters
            if not scan_hidden and not scan_security:
                continue

            # Hidden text scan
            if scan_hidden:
                file_findings.extend(self.hidden_scanner.scan_file(file_path))

            # Shell security scan
            if scan_security:
                file_findings.extend(self.shell_scanner.scan_file(file_path))

            # Filter by severity
            filtered = [f for f in file_findings if f.severity.value >= severity_filter.value]

            if filtered:
                result.findings.extend(filtered)
            else:
                result.clean_files.append(str(file_path))

            result.files_scanned += 1

        return result


def print_human_report(result: ScanResult):
    """Print human-readable report"""
    print(f"\n{'='*80}")
    print(f"sec-skills-audit Report")
    print(f"{'='*80}\n")

    print(f"Files scanned: {result.files_scanned}")
    print(f"Clean files: {len(result.clean_files)}")
    print(f"Files with findings: {len(set(f.file_path for f in result.findings))}\n")

    if result.findings:
        # Group by severity
        by_severity = {}
        for finding in result.findings:
            severity = finding.severity.name
            by_severity.setdefault(severity, []).append(finding)

        for severity in sorted(by_severity.keys(), key=lambda s: Severity[s].value, reverse=True):
            findings = by_severity[severity]
            print(f"\n{severity} ({len(findings)} issues)")
            print("-" * 80)
            for f in findings:
                print(f"  {f.file_path}:{f.line_number}")
                print(f"    {f.description}")
                if f.snippet:
                    print(f"    Snippet: {f.snippet}")
                print()
    else:
        print("No issues found!")

    print(f"\nMax severity: {result.max_severity().name}")


def print_json_report(result: ScanResult):
    """Print JSON report"""
    data = {
        "files_scanned": result.files_scanned,
        "clean_files": len(result.clean_files),
        "max_severity": result.max_severity().name,
        "findings": [
            {
                "file": f.file_path,
                "line": f.line_number,
                "type": f.issue_type,
                "severity": f.severity.name,
                "description": f.description,
                "snippet": f.snippet,
            }
            for f in result.findings
        ],
    }
    print(json.dumps(data, indent=2))


def main():
    parser = argparse.ArgumentParser(
        description="Security audit tool for OpenCode skill files",
        epilog="""
Examples:
  %(prog)s --path ~/.config/opencode/skill
  %(prog)s --path . --file-type markdown --min-severity MEDIUM
  %(prog)s --path . --file-type script --file-type markdown
  %(prog)s --path . --file-type script --min-severity HIGH --format json
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        '--path',
        type=Path,
        default=Path('~/.config/opencode/skill'),
        help='Base path to scan (default: ~/.config/opencode/skill)'
    )
    parser.add_argument(
        '--format',
        choices=['human', 'json'],
        default='human',
        help='Output format (default: human)'
    )
    parser.add_argument(
        '--min-severity',
        choices=['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'],
        default='LOW',
        help='Minimum severity to report (default: LOW)'
    )
    parser.add_argument(
        '--file-type',
        action='append',
        choices=['all', 'markdown', 'script'],
        dest='file_types',
        help='File types to scan (default: all). Can be specified multiple times for multiple types.'
    )

    args = parser.parse_args()

    # Parse file types
    file_types = []
    if args.file_types:
        file_types = [FileType(ft) for ft in args.file_types]
    else:
        file_types = [FileType.ALL]

    # Run audit
    auditor = SkillAuditor(args.path, file_types)
    severity_filter = Severity[args.min_severity]
    result = auditor.scan_all(severity_filter)

    # Print report
    if args.format == 'json':
        print_json_report(result)
    else:
        print_human_report(result)

    # Exit code based on severity
    max_sev = result.max_severity()
    if max_sev in (Severity.HIGH, Severity.CRITICAL):
        sys.exit(2)
    elif max_sev in (Severity.LOW, Severity.MEDIUM):
        sys.exit(1)
    else:
        sys.exit(0)


if __name__ == '__main__':
    main()
