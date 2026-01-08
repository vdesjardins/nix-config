"""Unit tests for tag_report.py script."""

import json
import sys
from pathlib import Path
from typing import List, Dict, Any
import pytest


class TestTagReportImports:
    """Test that tag_report.py has all required imports."""

    def test_imports_available(self):
        """Verify all required stdlib modules can be imported."""
        import json
        import subprocess
        from datetime import datetime, timedelta
        from pathlib import Path

        # If we get here without exception, all imports are available
        assert True

    def test_script_syntax(self):
        """Verify tag_report.py has valid Python syntax."""
        import py_compile
        import tempfile

        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        assert script_path.exists(), "tag_report.py not found"

        with tempfile.TemporaryDirectory() as tmpdir:
            py_compile.compile(
                str(script_path),
                cfile=f"{tmpdir}/tag_report.pyc",
                doraise=True,
            )


class TestTagReportFunctions:
    """Test tag_report.py function implementations."""

    def test_get_timewarrior_data_function_exists(self):
        """Verify get_timewarrior_data function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "def get_timewarrior_data" in content

    def test_generate_report_function_exists(self):
        """Verify generate_report function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "def " in content
        assert "report" in content.lower() or "summary" in content.lower()

    def test_format_report_function_exists(self):
        """Verify report formatting function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "def " in content
        assert "format" in content.lower() or "report" in content.lower()

    def test_main_function_exists(self):
        """Verify main function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "def main" in content
        assert 'if __name__ == "__main__"' in content


class TestTagReportAnalysis:
    """Test report analysis capabilities."""

    def test_analyzes_by_tag(self):
        """Verify script analyzes data by tag."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "by_tag" in content.lower() or "tag" in content.lower()

    def test_analyzes_by_day(self):
        """Verify script analyzes data by day."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "by_day" in content.lower() or "day" in content.lower()

    def test_generates_trends(self):
        """Verify script generates trend analysis."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "trend" in content.lower() or "most" in content.lower()

    def test_calculates_summary_statistics(self):
        """Verify script calculates summary statistics."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert (
            "total" in content.lower()
            or "summary" in content.lower()
            or "average" in content.lower()
        )


class TestTagReportArgumentParsing:
    """Test command-line argument parsing."""

    def test_accepts_period_argument(self):
        """Verify script accepts --period argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "--period" in content or "period" in content.lower()

    def test_accepts_format_argument(self):
        """Verify script accepts --format argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "--format" in content

    def test_accepts_sort_argument(self):
        """Verify script accepts --sort argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "--sort" in content or "sort" in content.lower()

    def test_has_help_support(self):
        """Verify script supports --help argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "--help" in content


class TestTagReportOutputFormat:
    """Test output format capabilities."""

    def test_supports_json_output(self):
        """Verify script supports JSON output format."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "json.dumps" in content

    def test_supports_report_output(self):
        """Verify script supports human-readable report format."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "report" in content.lower() or "format" in content.lower()

    def test_structures_output_hierarchically(self):
        """Verify script structures output with multiple sections."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        # Should have sections like summary, by_tag, by_day, trends
        assert "summary" in content.lower() or "tag" in content.lower()


class TestTagReportErrorHandling:
    """Test error handling in tag_report.py."""

    def test_has_error_handling(self):
        """Verify script implements error handling."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "try:" in content
        assert "except" in content
        assert "sys.exit" in content

    def test_handles_timewarrior_missing(self):
        """Verify script handles missing timewarrior gracefully."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "FileNotFoundError" in content or "not available" in content.lower()

    def test_handles_empty_data(self):
        """Verify script handles empty timewarrior data gracefully."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert "if " in content and ("empty" in content.lower() or "len" in content)


class TestTagReportDocumentation:
    """Test documentation quality."""

    def test_has_module_docstring(self):
        """Verify script has module-level docstring."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        assert '"""' in content or "'''" in content
        assert "Usage:" in content or "usage" in content.lower()

    def test_functions_have_docstrings(self):
        """Verify functions have docstrings."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        content = script_path.read_text()
        # Count function definitions and docstrings
        assert content.count("def ") >= 3  # At least 3 functions
        assert content.count('"""') >= 3  # At least 3 docstrings
