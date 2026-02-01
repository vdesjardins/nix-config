# Bootstrap Nix MCP Server Guide

**Purpose:** Clear, actionable steps to add a new MCP server to nix-config
following the established pattern.

## Prerequisites

- GitHub repository URL for the MCP server
- NPM-based or buildable package (e.g., `buildNpmPackage`)
- Decision: enabled by default in role aggregator or disabled?

## 6-Step Bootstrap Process

### 1. PLAN THE DEFAULTS

Determine configuration defaults:

- **Role aggregator default:** `true` or `false`?
- **Per-agent defaults:** Disabled by default (set `enabled = false` where
  needed)
- **Custom options:** Shell type, API keys, etc. (default values)

### 2. CREATE PACKAGE

**File:** `packages/{name}/package.nix`

```nix
{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "{name}";
  version = "{version}";

  src = fetchFromGitHub {
    owner = "{github-owner}";
    repo = "{repo-name}";
    rev = "{commit-sha}";  # Pin to specific commit or tag
    hash = lib.fakeHash;  # Placeholder - will be replaced
  };

  npmDepsHash = lib.fakeHash;  # Placeholder - will be replaced

  mainProgram = "{binary-name}";

  meta = with lib; {
    description = "MCP Server description";
    homepage = "https://github.com/{owner}/{repo}";
    license = licenses.mit;
  };
}
```

**Computing Hashes:**

1. Use `lib.fakeHash` as placeholder for both `hash` and `npmDepsHash`
2. Run `nix build '.#{name}'` - it will fail with the correct hash
3. Copy the reported hash from error message into the respective field
4. Repeat until `nix build '.#{name}'` succeeds completely
5. Verify the built binary exists: `nix build '.#{name}' && ls -la result/bin/`

**After creating:**

```bash
git add packages/{name}/
```

### 3. CREATE MCP MODULE

**File:** `home/modules/modules/mcp/{name}/default.nix`

**Reference:** Copy structure from similar MCP (e.g., `grafana`, `context7`,
`fetch`)

```nix
{
  config,
  lib,
  my-packages,
  ...
}:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption types mkIf getExe;
  cfg = config.modules.mcp.{name};
in
{
  options.modules.mcp.{name} = {
    enable = mkEnableOption "{name} MCP server";

    package = mkPackageOption my-packages "{name}" {};

    # Add custom options as needed (e.g., shellType, apiKey, etc.)
    shellType = mkOption {
      type = types.str;
      default = "zsh";
      description = "Shell type to use";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      # 1. Neovim (mcphub)
      desktop.editors.nixvim.ai.mcpServers.{name} = {
        command = getExe cfg.package;
        args = ["--shell-type" cfg.shellType];
        # Add env, tools, etc. as needed
      };

      # 2. UTCP Code Mode
      mcp.utcp-code-mode.mcpServers.{name} = {
        transport = "stdio";
        command = getExe cfg.package;
        args = ["--shell-type" cfg.shellType];
        # Add env, sessionVariables, etc. as needed
      };

      # 3. GitHub Copilot CLI
      shell.tools.github-copilot-cli.settings.mcpServers.{name} = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = ["--shell-type" cfg.shellType];
        # Add environment, etc. as needed
      };
    };

    # 4. OpenCode CLI (disabled by default)
    programs.opencode.settings.mcp.{name} = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package) "--shell-type" cfg.shellType];
    };
  };
}
```

**Key points:**

- Use `getExe cfg.package` for command paths
- Wrap entire config in `mkIf cfg.enable`
- For OpenCode, set `enabled = false` to disable by default
- For other agents, absence of `enabled` flag means enabled by presence of
  config
- Use `mkOption` for custom settings (shell type, API keys, etc.)

**After creating:**

```bash
git add home/modules/modules/mcp/{name}/
```

### 4. UPDATE ROLE AGGREGATOR

**File:** `home/modules/roles/ai/tools.nix`

**Add to `options.roles.ai.tools.mcp` section:**

```nix
{name}.enable = mkOption {
  type = types.bool;
  default = true;  # or false
  description = "Enable {name} MCP server";
};
```

**Add to `config.modules.mcp` section:**

```nix
{name}.enable = cfg.mcp.{name}.enable;
```

### 5. LINT & VALIDATE

```bash
# Format code with alejandra and other pre-commit hooks
nix develop -c prek run -a

# Validate nix evaluation (shows package in outputs)
nix flake check

# Optional: Full build test
nix develop -c make hm/generate
```

### 6. VERIFY & COMMIT

**Check git status:**

```bash
git status --short
# Expected output:
# A  packages/{name}/package.nix
# AM home/modules/modules/mcp/{name}/default.nix
# M  home/modules/roles/ai/tools.nix
```

**All checks should pass:**

- ✅ `prek run -a` passes
- ✅ `nix flake check` validates
- ✅ 3 files staged in git

**Ready to commit or apply:**

```bash
# Create a new change with jujutsu
jj new -A @

# Or apply immediately
make hm/apply
```

## Key Patterns & Conventions

### Module Auto-Discovery

- Packages in `packages/` directory are auto-discovered by flake
- MCP modules in `home/modules/modules/mcp/` are auto-discovered via
  `mapModulesRecursive'`
- No manual registration needed; just create the files and git add them

### Agent Integration Structure

```text
mkIf cfg.enable {
  modules = {
    # Neovim, UTCP, GitHub Copilot CLI configs here
  };
  # OpenCode config here (outside modules block)
}
```

### Enabled/Disabled Logic

- **Neovim, UTCP, GitHub CLI:** Enabled by presence of configuration (no
  explicit `enabled` flag)
- **OpenCode:** Must explicitly set `enabled = false` to disable
- **Per-agent options:** Not needed; just set `enabled = false` in the config

### Custom Options Pattern

```nix
# In options:
shellType = mkOption {
  type = types.str;
  default = "zsh";
  description = "Shell type to use";
};

# In config (use cfg.shellType):
args = ["--shell-type" cfg.shellType];
```

### Common Option Types

```nix
mkEnableOption "description"                    # Boolean enable/disable
mkPackageOption pkgs "name" {}                  # Package option
mkOption {type = types.str; default = "..."}   # String with default
mkOption {type = types.path; ...}              # File path
mkOption {type = types.attrs; ...}             # Nested config object
```

## Validation Checklist

- [ ] Package file created at `packages/{name}/package.nix`
- [ ] Package builds successfully: `nix build '.#{name}'`
- [ ] Binary exists in build output: `nix build '.#{name}' && ls result/bin/`
- [ ] MCP module file created at `home/modules/modules/mcp/{name}/default.nix`
- [ ] Role aggregator updated with option and config
- [ ] `git add` run on package and module directories
- [ ] `prek run -a` passes (all formatting correct)
- [ ] `nix flake check` shows package in outputs
- [ ] 3 files staged in git
- [ ] Ready to commit with `jj new -A @` or apply with `make hm/apply`

## Example: Full tmux-mcp Implementation

Reference complete implementation:

- Package: `packages/tmux-mcp/package.nix`
- Module: `home/modules/modules/mcp/tmux-mcp/default.nix`
- Role changes: `home/modules/roles/ai/tools.nix`

Follow the same structure for any new MCP server.

## Troubleshooting

**Package hash errors during `nix build`:**

- Start with `lib.fakeHash` for both `hash` and `npmDepsHash`
- Run `nix build '.#{name}'` - build will fail
- Error message shows correct hash: "expected sha256-..."
- Copy hash value (just the `sha256-...` part) into the file
- For `hash`: Error appears first when fetching source
- For `npmDepsHash`: Error appears after source is fetched, during npm
  deps phase
- Re-run `nix build '.#{name}'` after each fix until build succeeds
- **Never use `nix flake check` for hash calculation** - always use `nix build`

**Verifying successful build:**

```bash
nix build '.#{name}'
nix build '.#{name}' --print-out-paths  # Shows output directory
ls result/bin/  # Verify binary exists and is executable
```

**Module not discovered:**

- Ensure directory structure is exactly:
  `home/modules/modules/mcp/{name}/default.nix`
- Run `git add home/modules/modules/mcp/{name}/` to stage the new module
- Nix flake won't see unstaged files

**Pre-commit formatting issues:**

- Run `nix develop -c prek run -a` to auto-fix
- Check alejandra formatting for Nix files
- Check stylua formatting for Lua files

**"Option ... does not exist" errors:**

- Verify all 4 agent paths are correct (copy-paste from existing MCPs)
- Check that you have `modules = { ... }` wrapper for Neovim/UTCP/GitHub CLI
- OpenCode config should be outside the `modules` block

## Quick Reference: Common MCP Paths

```text
Neovim:          modules.desktop.editors.nixvim.ai.mcpServers.{name}
UTCP Code Mode:  modules.mcp.utcp-code-mode.mcpServers.{name}
GitHub CLI:      shell.tools.github-copilot-cli.settings.mcpServers.{name}
OpenCode:        programs.opencode.settings.mcp.{name}
```

All require:

- `command = getExe cfg.package`
- Optional: `args`, `env`, `tools`, `transport`, `type`
- OpenCode only: `enabled = false`
