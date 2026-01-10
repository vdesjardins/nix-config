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
- Build a package: `nix build '.#<package>`
- Update flake inputs: `nix flake update`
- Lint (all): Run `pre-commit run -a` or use `nix flake check`
- Update packages: Run `./infra.nu nix-update`

## Post-Change Quality Assurance

After making any code changes:
1. **Always run `pre-commit run -a`** to check for linting and formatting issues
2. **Fix any errors** that pre-commit auto-fixes (alejandra formatting, etc.)
3. **Do not create INTENTS-*.md files** for pre-commit formatting fixes (they're part of the original change)
4. Do not commit except if explicitly told to do so

## Code Style Guidelines

All code formatting is enforced by `.editorconfig` and pre-commit hooks. See `.editorconfig` for base formatting rules.

### Language-Specific Tools
- **Nix files**: Formatted by `alejandra` (enforced via pre-commit)
- **Lua files**: Formatted by `stylua` with 100 column width, double quotes preferred (see .luacheckrc for globals)
- **Shell files**: Formatted by `shfmt` (enforced via pre-commit)
- **Markdown**: Keep readable; checked by `rumdl`

### Linting Tools (run automatically via `pre-commit run -a`)
- `alejandra` - Nix code formatter
- `statix` - Nix linter
- `stylua` - Lua code formatter
- `shellcheck` - Shell script linter
- `shfmt` - Shell script formatter
- `commitizen` - Commit message validator

### Additional Guidelines
- Follow idiomatic conventions for each language
- Use appropriate error handling patterns for each language
- Use idiomatic import/include patterns for each language
- Lua globals: Only `vim` is allowed (see .luacheckrc)
- When adding a new file in the automatically discovered paths you need to
to a `git add <file>` for nix flake to see it.

## Project Structure

- Root/ repository contains configuration, modules, hosts, packages, overlays.
- **home/** – Home-manager specific NixOS modules.
- **home/users** - Home-manager user configurations.
- **home/modules** - Home-managers modules and roles - automatically discovered by flake.nix.
- **home/modules/roles** – Home-manager roles grouping reusable modules.
- **home/modules/modules** – Home-manager reusable modules.
- **hosts/** – NixOS host-specific configurations.
- **hosts/modules/** - NixOS reusable modules.
- **hosts/systems**/ - NixOS hosts configurations.
- **lib/** – Shared Nix helpers and nixos definitions.
- **overlays/** – Nixpkgs overlays for custom packages - automatically discovered by flake.nix.
- **packages/** – Nix packages - automatically discovered by flake.nix.
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
