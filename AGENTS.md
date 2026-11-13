# AGENTS.md

## Commands and Validation

Run builds, linters, and project scripts through `nix develop -c <command>`.
File inspection and version-control commands do not require the development shell.

- Build user configuration: `make hm/generate`
- Build system configuration: `make host/generate`
- Apply user configuration: `make hm/apply`
- Apply system configuration: `make host/apply`
- Build a package: `nix build '.#<package>'`
- Lint and format: `prek run -a`
- Update packages when requested: `./infra.nu nix-update`

After code changes, run `prek run -a`, inspect any auto-fixes, and rerun until it
passes. Report checks you cannot complete. Follow `.editorconfig` and the
pre-commit configuration; these are authoritative for formatting and linting.
Prefer targeted validation of affected packages and configurations. A build does
not prove runtime integration works; report what was actually tested.

## Boundaries

- Do not run apply targets unless requested.
- Do not describe, create, rearrange, or publish VCS changes unless requested.
  Read-only VCS commands and automatic Jj snapshots are allowed.
- Do not update flake inputs unless requested; prefer targeted updates to avoid
  unrelated upstream changes.
- Compute package hashes using targeted `nix build` errors, not `nix flake check`.
- When API or CLI behavior is uncertain, verify it against authoritative upstream
  documentation or source for the pinned version.

## Repository Conventions

- Home Manager reusable modules live in `home/modules/modules/`; roles group
  modules under `home/modules/roles/`.
- Home Manager modules, packages in `packages/`, and overlays in `overlays/` are
  automatically discovered by `flake.nix`.
- Ensure new files are visible to the flake source: stage them in Git repositories;
  in Jj repositories, verify they are tracked by the working change.

## Bootstrap Guides

Consult the applicable guide and a similar existing implementation when adding
a package, module, or MCP server:

- [Nix packages](docs/NIX_PACKAGE_BOOTSTRAP.md)
- [Home Manager modules](docs/HM_MODULE_BOOTSTRAP.md)
- [MCP integration](docs/MCP_BOOTSTRAP_GUIDE.md)

## Commit Policy

Use the conventional-commits skill when available. Explain WHY, not just WHAT.
Repository-specific emoji prefixes:

- `feat` ✨, `fix` 🐛, `docs` 📝, `refactor` ♻️, `style` 🎨
- `perf` ⚡️, `test` ✅, `chore` 🧑‍💻, `wip` 🚧, `remove` 🔥
- `hotfix` 🚑, `security` 🔒

Format: `<emoji> <type>(<scope>): <description>`, with an optional body and footer.
