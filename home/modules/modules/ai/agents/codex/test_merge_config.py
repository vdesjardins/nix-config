"""Regression tests for writable Codex config and Nix-owned settings."""

import importlib.util
from pathlib import Path
import tempfile
import unittest

import tomlkit

spec = importlib.util.spec_from_file_location("merge_config", Path(__file__).with_name("merge-config.py"))
merger = importlib.util.module_from_spec(spec)
spec.loader.exec_module(merger)


class MergeConfigTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.source = self.root / "nix-config.toml"
        self.destination = self.root / "config.toml"
        self.manifest = self.root / "nix-managed.json"

    def apply(self, content):
        self.source.write_text(content)
        merger.merge(self.source, self.destination, self.manifest)
        return tomlkit.parse(self.destination.read_text()).unwrap()

    def test_preserves_trust_and_unmanaged_servers(self):
        self.destination.write_text(
            '# Keep this comment\n[projects."/work"]\ntrust_level = "trusted"\n'
            '[mcp_servers.personal]\ncommand = "personal"\n'
        )
        result = self.apply('[mcp_servers.git]\ncommand = "git-mcp"\n')
        self.assertEqual(result["projects"]["/work"]["trust_level"], "trusted")
        self.assertIn("personal", result["mcp_servers"])
        self.assertIn("# Keep this comment", self.destination.read_text())
        # Codex must be able to persist runtime state without following a store link.
        self.assertFalse(self.destination.is_symlink())
        self.assertEqual(self.destination.stat().st_mode & 0o777, 0o600)

    def test_removes_disabled_module_and_preserves_runtime_changes(self):
        self.apply('[mcp_servers.git]\ncommand = "old"\n[mcp_servers.keep]\ncommand = "keep"\n')
        with self.destination.open("a") as output:
            output.write('[projects."/work"]\ntrust_level = "trusted"\n')
        result = self.apply('[mcp_servers.keep]\ncommand = "new"\n')
        self.assertNotIn("git", result["mcp_servers"])
        self.assertEqual(result["mcp_servers"]["keep"]["command"], "new")
        self.assertEqual(result["projects"]["/work"]["trust_level"], "trusted")

    def test_replaces_symlink_without_modifying_target(self):
        target = self.root / "store-config.toml"
        original = '[projects."/work"]\ntrust_level = "trusted"\n'
        target.write_text(original)
        self.destination.symlink_to(target)
        result = self.apply('[mcp_servers.git]\ncommand = "git-mcp"\n')
        self.assertFalse(self.destination.is_symlink())
        self.assertEqual(target.read_text(), original)
        self.assertIn("projects", result)

    def test_invalid_config_is_not_overwritten(self):
        self.destination.write_text("[broken")
        with self.assertRaises(tomlkit.exceptions.ParseError):
            self.apply('[mcp_servers.git]\ncommand = "git-mcp"\n')
        self.assertEqual(self.destination.read_text(), "[broken")
        self.assertFalse(self.manifest.exists())

    def test_repeated_activation_is_idempotent(self):
        content = '[mcp_servers.git]\ncommand = "git-mcp"\n'
        self.apply(content)
        first = self.destination.read_text()
        self.apply(content)
        self.assertEqual(self.destination.read_text(), first)


if __name__ == "__main__":
    unittest.main()
