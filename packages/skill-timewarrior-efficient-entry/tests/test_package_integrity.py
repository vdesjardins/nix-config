"""Unit tests for package integrity and structure."""

import os
from pathlib import Path
import pytest


class TestPackageStructure:
    """Test that the package has the expected directory structure."""

    def test_skill_directory_exists(self):
        """Verify skill-timewarrior-workflow directory exists."""
        skill_dir = Path(__file__).parent.parent
        assert skill_dir.exists()
        assert skill_dir.is_dir()

    def test_skill_md_exists(self):
        """Verify SKILL.md exists."""
        skill_md = Path(__file__).parent.parent / "SKILL.md"
        assert skill_md.exists()
        assert skill_md.is_file()

    def test_scripts_directory_exists(self):
        """Verify scripts directory exists."""
        scripts_dir = Path(__file__).parent.parent / "scripts"
        assert scripts_dir.exists()
        assert scripts_dir.is_dir()

    def test_tests_directory_exists(self):
        """Verify tests directory exists."""
        tests_dir = Path(__file__).parent
        assert tests_dir.exists()
        assert tests_dir.is_dir()


class TestScriptFiles:
    """Test that all required scripts exist."""

    def test_tag_analyzer_exists(self):
        """Verify tag_analyzer.py exists."""
        script = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        assert script.exists()
        assert script.is_file()

    def test_tag_fuzzy_search_exists(self):
        """Verify tag_fuzzy_search.py exists."""
        script = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        assert script.exists()
        assert script.is_file()

    def test_tag_report_exists(self):
        """Verify tag_report.py exists."""
        script = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        assert script.exists()
        assert script.is_file()


class TestSKILLMarkdown:
    """Test SKILL.md content and structure."""

    def test_skill_md_has_frontmatter(self):
        """Verify SKILL.md has proper frontmatter."""
        skill_md = Path(__file__).parent.parent / "SKILL.md"
        content = skill_md.read_text()
        assert content.startswith("---")
        assert "name:" in content
        assert "timewarrior" in content.lower()

    def test_skill_md_has_content(self):
        """Verify SKILL.md has substantial content."""
        skill_md = Path(__file__).parent.parent / "SKILL.md"
        content = skill_md.read_text()
        # Should have a reasonable amount of content
        assert len(content) > 1000

    def test_skill_md_references_scripts(self):
        """Verify SKILL.md references the Python scripts."""
        skill_md = Path(__file__).parent.parent / "SKILL.md"
        content = skill_md.read_text()
        # Should reference at least one script
        assert (
            "tag_analyzer" in content
            or "tag_fuzzy_search" in content
            or "tag_report" in content
        )

    def test_skill_md_ends_with_newline(self):
        """Verify SKILL.md ends with a newline."""
        skill_md = Path(__file__).parent.parent / "SKILL.md"
        content = skill_md.read_text()
        assert content.endswith("\n")


class TestScriptContent:
    """Test script file content integrity."""

    def test_scripts_have_shebangs(self):
        """Verify all scripts have a shebang line."""
        scripts_dir = Path(__file__).parent.parent / "scripts"
        for script in scripts_dir.glob("*.py"):
            content = script.read_text()
            assert content.startswith("#!"), f"{script.name} missing shebang"
            first_line = content.split("\n")[0]
            assert "python" in first_line.lower(), f"{script.name} shebang not for python"

    def test_scripts_have_docstrings(self):
        """Verify all scripts have module docstrings."""
        scripts_dir = Path(__file__).parent.parent / "scripts"
        for script in scripts_dir.glob("*.py"):
            content = script.read_text()
            # Skip shebang line
            lines = content.split("\n")[1:]
            content_without_shebang = "\n".join(lines)
            assert (
                '"""' in content_without_shebang or "'''" in content_without_shebang
            ), f"{script.name} missing docstring"

    def test_scripts_end_with_newline(self):
        """Verify all scripts end with a newline."""
        scripts_dir = Path(__file__).parent.parent / "scripts"
        for script in scripts_dir.glob("*.py"):
            content = script.read_text()
            assert content.endswith("\n"), f"{script.name} doesn't end with newline"

    def test_scripts_import_json(self):
        """Verify all scripts import json module."""
        scripts_dir = Path(__file__).parent.parent / "scripts"
        for script in scripts_dir.glob("*.py"):
            content = script.read_text()
            assert "import json" in content, f"{script.name} doesn't import json"

    def test_scripts_import_subprocess(self):
        """Verify scripts import subprocess for timewarrior calls."""
        scripts_dir = Path(__file__).parent.parent / "scripts"
        for script in scripts_dir.glob("*.py"):
            content = script.read_text()
            assert (
                "import subprocess" in content
            ), f"{script.name} doesn't import subprocess"

    def test_scripts_have_main_guard(self):
        """Verify all scripts have main guard."""
        scripts_dir = Path(__file__).parent.parent / "scripts"
        for script in scripts_dir.glob("*.py"):
            content = script.read_text()
            assert (
                'if __name__ == "__main__"' in content
            ), f"{script.name} missing main guard"


class TestPythonSyntax:
    """Test Python syntax validity."""

    def test_tag_analyzer_syntax(self):
        """Verify tag_analyzer.py has valid Python syntax."""
        import py_compile
        import tempfile

        script = Path(__file__).parent.parent / "scripts" / "tag_analyzer.py"
        with tempfile.TemporaryDirectory() as tmpdir:
            py_compile.compile(str(script), cfile=f"{tmpdir}/test.pyc", doraise=True)

    def test_tag_fuzzy_search_syntax(self):
        """Verify tag_fuzzy_search.py has valid Python syntax."""
        import py_compile
        import tempfile

        script = Path(__file__).parent.parent / "scripts" / "tag_fuzzy_search.py"
        with tempfile.TemporaryDirectory() as tmpdir:
            py_compile.compile(str(script), cfile=f"{tmpdir}/test.pyc", doraise=True)

    def test_tag_report_syntax(self):
        """Verify tag_report.py has valid Python syntax."""
        import py_compile
        import tempfile

        script = Path(__file__).parent.parent / "scripts" / "tag_report.py"
        with tempfile.TemporaryDirectory() as tmpdir:
            py_compile.compile(str(script), cfile=f"{tmpdir}/test.pyc", doraise=True)


class TestImportsAvailable:
    """Test that all required imports are available."""

    def test_stdlib_imports(self):
        """Verify all required stdlib modules can be imported."""
        import json
        import subprocess
        import sys
        from datetime import datetime, timedelta
        from pathlib import Path
        import difflib

        # If we get here without exception, all imports are available
        assert True
