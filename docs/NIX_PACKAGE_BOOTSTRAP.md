# Adding Nix Packages

## Integration

- Check existing flake inputs and upstream flakes before creating a local
  derivation. Add or update inputs only when requested.
- Local packages live at `packages/<name>/package.nix` and are discovered by
  `lib.packagesFromDirectoryRecursive` in `flake.nix`; no registry edit is needed.
- Follow a similar package and use a builder suited to upstream's build system.
  Pin the source and dependency hashes; set `meta.mainProgram` to the installed
  executable, with description, homepage, license, and supported platforms.
- Make new files visible to the flake: stage them in Git, or verify that Jj tracks
  them in the working change. Package discovery does not require a flake update.

## Hashes and Validation

Run commands through the development shell:

```bash
nix develop -c nix build '.#<name>'
nix develop -c prek run -a
```

For new fixed-output hashes, start with `lib.fakeHash`, build the specific
package, and replace the placeholder with the **computed `got:` hash**, not the
`specified:` or expected value. Repeat for dependency hashes as needed. Do not
use `nix flake check` to compute hashes or assume every builder needs two hashes.

Inspect formatter changes and rerun checks until they pass. Verify the installed
entry point with a harmless command such as `--version` or `--help`; where
relevant, test runtime dependency resolution, not just compilation. Report any
untested platforms or integrations.

If exposing the package through Home Manager, follow the
[Home Manager guide](HM_MODULE_BOOTSTRAP.md) and build the affected configuration.
Do not activate or change VCS history without permission.

## Examples

- [context7](../packages/context7/package.nix): npm package with a committed lockfile.
- [openshell](../packages/openshell/package.nix): Rust source build and sandbox tests.
- [tmux-mcp](../packages/tmux-mcp/package.nix): Node package and runtime integration.
