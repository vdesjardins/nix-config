# AGENTS.md

## Build, Lint, and Apply Commands
- Build/apply user config: `make hm/apply`
- Build/apply system config: `make host/apply`
- Build only: `make hm/generate` or `make host/generate`
- Update flake inputs: `make flake-update`
- Lint (all): Run pre-commit hooks or use `nix flake check`

## Code Style Guidelines
- **Lua**: 4-space indents (stylua), 100 column width, Unix line endings, double quotes preferred
- **Nix**: 2-space indents, UTF-8, final newlines (see .editorconfig)
- **General**: Use spaces, not tabs; always end files with a newline
- **Globals**: Lua allows `vim` as a global (see .luacheckrc)
- **Linting**: Use alejandra, statix, stylua, shellcheck, shfmt, commitizen (see flake.nix)
- **Naming**: Follow idiomatic Lua/Nix conventions
- **Error Handling**: Use idiomatic error handling for each language
- **Imports**: Use idiomatic import/include patterns for Lua and Nix
- **No Cursor or Copilot rules present**

Keep this file up to date as conventions evolve.