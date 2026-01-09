# AGENTS.md

## Build, Lint, and Apply Commands

Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask.

All commands should be executed inside a Nix shell.  Start a shell with:
```zsh
nix develop

```
Once inside the shell, you can run the make targets shown below.
- Build/apply user config: `make hm/apply`
- Build/apply system config: `make host/apply`
- Build only user config: `make hm/generate`
- Build only system config: `make host/generate`
- Update flake inputs: `nix flake update`
- Lint (all): Run `pre-commit run -a` or use `nix flake check`
- Update packages: Run `./infra.nu nix-update`

## Code Style Guidelines

- **Lua**: 2-space indents (stylua), 100 column width, Unix line endings, double quotes preferred
- **Nix**: 2-space indents, UTF-8, final newlines (see .editorconfig)
- **General**: Use spaces, not tabs; always end files with a newline
- **Globals**: Lua allows `vim` as a global (see .luacheckrc)
- **Linting**: Use alejandra, statix, stylua, shellcheck, shfmt, commitizen (see flake.nix)
- **Naming**: Follow idiomatic Lua/Nix conventions
- **Error Handling**: Use idiomatic error handling for each language
- **Imports**: Use idiomatic import/include patterns for Lua and Nix
- **No Cursor or Copilot rules present**

## Project Structure

- Root/ repository contains configuration, modules, hosts, packages, overlays.
- **home/** – Home-manager specific NixOS modules.
- **home/users** - Home-manager user configurations.
- **home/modules/roles** – Home-manager roles grouping reusable modules.
- **home/modules/modules** – Home-manager reusable modules.
- **hosts/** – NixOS host-specific configurations.
- **hosts/modules/** - NixOS reusable modules.
- **hosts/systems**/ - NixOS hosts configurations.
- **lib/** – Shared Nix helpers and nixos definitions.
- **overlays/** – Nixpkgs overlays for custom packages.
- **packages/** – Nix packages
- **.github/** – GitHub Actions workflows.
- **.envrc** – Environment variables for the Nix shell.
- **Makefile** – Build targets.
- **flake.nix** – Flake definition.
- **default.nix** – Default NixOS configuration.
- **infra.nu** – Build helpers for dependency management

## Commit Style Guide

We follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) style for our commit messages.
Explain WHY not just the WHAT.

### Commit Types

Each commit type has a corresponding emoji that must appear at the start of
the message:

| Type | Emoji | Description |
|------|-------|-------------|
| feat | ✨ | New features |
| fix | 🐛 | Bug fixes |
| docs | 📝 | Documentation changes |
| refactor | ♻️ | Code restructuring without changing functionality |
| style | 🎨 | Code formatting, missing semicolons, etc. |
| perf | ⚡️ | Performance improvements |
| test | ✅ | Adding or correcting tests |
| chore | 🧑‍💻 | Tooling, configuration, maintenance |
| wip | 🚧 | Work in progress |
| remove | 🔥 | Removing code or files |
| hotfix | 🚑 | Critical fixes |
| security | 🔒 | Security improvements |


### Message Format

```text
<emoji> <type>(<scope>): <description>

[optional body explaining why, not what]

[optional footer with references]
```

**Examples:**

- `✨ feat(auth): add two-factor authentication support`
- `🐛 fix(api): resolve race condition in request handler`
- `♻️ refactor(parser): simplify token parsing logic`
- `📝 docs(readme): update installation instructions`
