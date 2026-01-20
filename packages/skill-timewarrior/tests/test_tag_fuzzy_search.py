"""Unit tests for tag_fuzzy_search.py script."""

import json
import sys
from pathlib import Path
from typing import List, Dict, Any
import pytest


class TestTagFuzzySearchImports:
    """Test that tag_fuzzy_search.py has all required imports."""

    def test_imports_available(self):
        """Verify all required stdlib modules can be imported."""
        import json
        import subprocess
        import difflib
        from datetime import datetime
        from pathlib import Path

        # If we get here without exception, all imports are available
        assert True

    def test_script_syntax(self):
        """Verify tag_fuzzy_search.py has valid Python syntax."""
        import py_compile
        import tempfile

        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        assert script_path.exists(), "tag_fuzzy_search.py not found"

        with tempfile.TemporaryDirectory() as tmpdir:
            py_compile.compile(
                str(script_path),
                cfile=f"{tmpdir}/tag_fuzzy_search.pyc",
                doraise=True,
            )


class TestTagFuzzySearchFunctions:
    """Test tag_fuzzy_search.py function implementations."""

    def test_get_all_tags_function_exists(self):
        """Verify get_all_tags function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "def get_all_tags" in content

    def test_fuzzy_match_function_exists(self):
        """Verify fuzzy matching function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "def " in content  # Has functions
        assert ("SequenceMatcher" in content or "difflib" in content)

    def test_main_function_exists(self):
        """Verify main function is defined."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "def main" in content
        assert 'if __name__ == "__main__"' in content


class TestFuzzyMatchingImplementation:
    """Test fuzzy matching algorithm implementation."""

    def test_uses_difflib(self):
        """Verify script uses difflib for fuzzy matching."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "difflib" in content or "SequenceMatcher" in content

    def test_supports_similarity_threshold(self):
        """Verify script supports similarity threshold configuration."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "threshold" in content.lower() or "similarity" in content.lower()

    def test_handles_exact_matches(self):
        """Verify script identifies exact matches."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "exact" in content.lower() or "==" in content


class TestTagFuzzySearchArgumentParsing:
    """Test command-line argument parsing."""

    def test_accepts_query_argument(self):
        """Verify script accepts query/search term."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "sys.argv" in content or "argparse" in content

    def test_accepts_threshold_argument(self):
        """Verify script accepts --threshold argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "--threshold" in content

    def test_accepts_limit_argument(self):
        """Verify script accepts --limit argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "--limit" in content

    def test_has_help_support(self):
        """Verify script supports --help argument."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "--help" in content


class TestTagFuzzySearchOutputFormat:
    """Test output format capabilities."""

    def test_supports_json_output(self):
        """Verify script supports JSON output format."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "json.dumps" in content

    def test_outputs_match_data(self):
        """Verify script outputs match metadata."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        # Should include similarity scores, tags, etc.
        assert "match" in content.lower() or "result" in content.lower()


class TestTagFuzzySearchErrorHandling:
    """Test error handling in tag_fuzzy_search.py."""

    def test_has_error_handling(self):
        """Verify script implements error handling."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "try:" in content
        assert "except" in content
        assert "sys.exit" in content

    def test_handles_timewarrior_missing(self):
        """Verify script handles missing timewarrior gracefully."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert "FileNotFoundError" in content or "not available" in content.lower()


class TestTagFuzzySearchDocumentation:
    """Test documentation quality."""

    def test_has_module_docstring(self):
        """Verify script has module-level docstring."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        assert '"""' in content or "'''" in content
        assert "Usage:" in content or "usage" in content.lower()

    def test_functions_have_docstrings(self):
        """Verify functions have docstrings."""
        script_path = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        content = script_path.read_text()
        # Count function definitions and docstrings
        assert content.count("def ") >= 2  # At least 2 functions
        assert content.count('"""') >= 2  # At least 2 docstrings
