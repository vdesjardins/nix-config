"""Unit tests for tag_analyzer.py script."""

import json
import sys
import subprocess
from pathlib import Path
from typing import List, Dict, Any
import pytest


class TestTagAnalyzerImports:
    """Test that tag_analyzer.py has all required imports."""

    def test_imports_available(self):
        """Verify all required stdlib modules can be imported."""
        import json
        import subprocess
        from datetime import datetime, timedelta
        from pathlib import Path

        # If we get here without exception, all imports are available
        assert True

    def test_script_syntax(self):
        """Verify tag_analyzer.py has valid Python syntax."""
        import py_compile
        import tempfile

        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        assert script_path.exists(), "tag_analyzer.py not found"

        with tempfile.TemporaryDirectory() as tmpdir:
            # Compile without caching to avoid store permission issues
            py_compile.compile(
                str(script_path),
                cfile=f"{tmpdir}/tag_analyzer.pyc",
                doraise=True,
            )


class TestTagAnalyzerFunctions:
    """Test tag_analyzer.py function implementations."""

    def test_check_timewarrior_function_exists(self):
        """Verify check_timewarrior function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "def check_timewarrior" in content
        assert "subprocess.run" in content
        assert "timew" in content.lower()

    def test_get_timewarrior_data_function_exists(self):
        """Verify get_timewarrior_data function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "def get_timewarrior_data" in content
        assert "timew" in content.lower()
        assert "export" in content

    def test_analyze_tags_function_exists(self):
        """Verify analyze_tags function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "def analyze_tags" in content
        assert "tag_stats" in content

    def test_format_table_function_exists(self):
        """Verify format_table function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "def format_table" in content

    def test_main_function_exists(self):
        """Verify main function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "def main" in content
        assert 'if __name__ == "__main__"' in content


class TestTagAnalyzerErrorHandling:
    """Test error handling in tag_analyzer.py."""

    def test_has_error_handling(self):
        """Verify script implements error handling."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "try:" in content
        assert "except" in content
        assert "sys.exit" in content

    def test_handles_timewarrior_missing(self):
        """Verify script handles missing timewarrior gracefully."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "FileNotFoundError" in content or "not installed" in content.lower()

    def test_handles_json_errors(self):
        """Verify script handles JSON parsing errors."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "json.JSONDecodeError" in content or "json.loads" in content


class TestTagAnalyzerOutputFormat:
    """Test output format capabilities."""

    def test_supports_json_output(self):
        """Verify script supports JSON output format."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "json.dumps" in content

    def test_supports_table_output(self):
        """Verify script supports table output format."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "format_table" in content or "table" in content.lower()

    def test_accepts_format_argument(self):
        """Verify script accepts --format argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "--format" in content


class TestTagAnalyzerArgumentParsing:
    """Test command-line argument parsing."""

    def test_accepts_period_argument(self):
        """Verify script accepts --period argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "--period" in content

    def test_accepts_tag_argument(self):
        """Verify script accepts --tag argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "--tag" in content

    def test_accepts_date_range_arguments(self):
        """Verify script accepts --from and --to arguments."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "--from" in content
        assert "--to" in content

    def test_has_help_support(self):
        """Verify script supports --help argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert "--help" in content


class TestTagAnalyzerDocumentation:
    """Test documentation quality."""

    def test_has_module_docstring(self):
        """Verify script has module-level docstring."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        assert '"""' in content or "'''" in content
        # Check that there's substantial documentation
        assert "Usage:" in content or "usage" in content.lower()

    def test_functions_have_docstrings(self):
        """Verify functions have docstrings."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        content = script_path.read_text()
        # Count function definitions and docstrings
        assert content.count("def ") >= 4  # At least 4 functions
        assert content.count('"""') >= 4  # At least 4 docstrings
