# Bootstrap Home-Manager Module Guide

**Purpose:** Create a reusable Home-Manager module for any tool, service, or
configuration (not just MCP servers).

## Prerequisites

Before starting, answer these questions:

1. **Module Purpose:** What does this module configure?
   - Example: "MCP Server for tmux integration"
   - Example: "Neovim plugin configuration"
   - Example: "Development environment setup"

2. **Module Namespace:** Where should it live in the config hierarchy?
   - MCP servers: `modules.mcp.{name}`
   - Editors: `modules.desktop.editors.{name}`
   - Shells: `modules.shell.{name}`
   - Custom: `modules.{category}.{name}`

3. **Configuration Options:** What should users be able to configure?
   - Enable/disable toggle? (always yes)
   - Package selection? (usually yes)
   - Custom settings? (shell type, API keys, ports, etc.)
   - Environment variables? Paths? Arguments?

4. **Integration Points:** Where does this module integrate?
   - Standalone tool? (just package + options)
   - Neovim integration? (add to nixvim config)
   - CLI tool integration? (add to shell config)
   - Multiple integrations? (multiple config blocks)

5. **Default State:** Should it be enabled by default when imported?
   - MCP servers: typically false
   - Development tools: typically true
   - Optional features: false

## Step-by-Step Module Creation

### 1. UNDERSTAND THE PATTERN

Home-Manager modules in this codebase follow a standard structure:

```nix
{
  config,
  lib,
  pkgs,
  my-packages,  # Reference to packages in flake
  ...
}:
let
  cfg = config.modules.{category}.{name};
in
{
  options.modules.{category}.{name} = {
    # Option definitions
  };

  config = mkIf cfg.enable {
    # Configuration implementation
  };
}
```

**Key concepts:**

- `options.*` = what users can configure
- `config = mkIf cfg.enable { ... }` = only apply when enabled
- `cfg` = reference to current module's config values

### 2. CREATE MODULE FILE

**File:** `home/modules/modules/{category}/{name}/default.nix`

**Example template:**

```nix
{
  config,
  lib,
  my-packages,
  ...
}:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption types mkIf getExe;

  cfg = config.modules.{category}.{name};
in
{
  options.modules.{category}.{name} = {
    enable = mkEnableOption "{name}";

    package = mkPackageOption my-packages "{name}" {};

    # Add custom options as needed
    customSetting = mkOption {
      type = types.str;
      default = "default-value";
      description = "Description of what this does";
    };
  };

  config = mkIf cfg.enable {
    # Configuration goes here
    # Reference cfg.package, cfg.customSetting, etc.
  };
}
```

### 3. DEFINE OPTIONS

Options are what users can configure. Common patterns:

**Enable/Disable (always include):**

```nix
enable = mkEnableOption "module name";
```

**Package reference (usually include):**

```nix
package = mkPackageOption my-packages "{name}" {};
```

**String option with default:**

```nix
shellType = mkOption {
  type = types.str;
  default = "zsh";
  description = "Shell type to use";
};
```

**Boolean option:**

```nix
enableFeatureX = mkOption {
  type = types.bool;
  default = false;
  description = "Enable feature X";
};
```

**Path option:**

```nix
configPath = mkOption {
  type = types.path;
  default = ~/.config/tool;
  description = "Path to configuration directory";
};
```

**Nested attributes:**

```nix
settings = mkOption {
  type = types.attrs;
  default = {};
  description = "Custom settings";
};
```

**List of strings:**

```nix
plugins = mkOption {
  type = types.listOf types.str;
  default = [];
  description = "List of plugins to enable";
};
```

### 4. IMPLEMENT CONFIGURATION

Configuration is what actually gets set when the module is enabled:

**Simple tool configuration:**

```nix
config = mkIf cfg.enable {
  # Set up environment variable
  home.sessionVariables.TOOL_CONFIG = "${cfg.package}/etc/config";

  # Create symlink to config
  home.file.".config/tool/settings".source = cfg.configFile;

  # Activate service or program
  programs.tool.enable = true;
  programs.tool.settings = cfg.customSettings;
};
```

**Integration with existing modules:**

```nix
config = mkIf cfg.enable {
  modules = {
    # Integrate with shell
    shell.aliases.tool = "${getExe cfg.package}";

    # Integrate with editor
    desktop.editors.nixvim.plugins.{name} = {
      enable = true;
      settings = cfg.editorSettings;
    };

    # Integrate with other modules
    other-module.enable = true;
  };

  # Add environment variables
  home.sessionVariables = {
    TOOL_VAR = cfg.customSetting;
  };
};
```

### 5. REFERENCE EXISTING MODULES

Study similar modules to understand patterns:

```bash
# Look at existing modules in same category
ls home/modules/modules/{category}/

# Reference a complete module
cat home/modules/modules/{category}/existing-module/default.nix
```

Common reference modules in this codebase:

- MCP: `home/modules/modules/mcp/context7/`
- Shells: `home/modules/modules/shell/tools/`
- Editors: `home/modules/modules/desktop/editors/`

### 6. CREATE MODULE DIRECTORY AND FILE

```bash
mkdir -p home/modules/modules/{category}/{name}
touch home/modules/modules/{category}/{name}/default.nix
```

Stage in git:

```bash
git add home/modules/modules/{category}/{name}/
```

### 7. OPTIONAL: UPDATE ROLE AGGREGATOR

If this module should be exposed in a role (recommended):

**File:** `home/modules/roles/{role}/default.nix`

Add to options:

```nix
{name}.enable = mkOption {
  type = types.bool;
  default = true;  # or false
  description = "Enable {name}";
};
```

Add to config:

```nix
{name}.enable = cfg.{name}.enable;
```

This allows users to control the module via: `roles.{role}.{name}.enable`

### 8. LINT & VALIDATE

```bash
nix develop -c pre-commit run -a
nix flake check
```

## Common Patterns

### Using getExe for Binary Paths

```nix
command = getExe cfg.package;
```

Always use `getExe` instead of hardcoding paths. It ensures the correct
binary is used regardless of nix store location.

### Conditional Configuration with mkIf

```nix
config = mkIf cfg.enable {
  # Only applied if enable = true
};

# Or for nested conditions:
nested-option = mkIf cfg.someFlag {
  # Only applied if flag is true
};
```

### Using lib.foldl' for Complex Options

```nix
finalSettings = lib.foldl' (acc: plugin: acc // {${plugin} = {};})
  {} cfg.plugins;
```

### Module Dependencies

If this module needs another module enabled first:

```nix
config = mkIf cfg.enable {
  # Ensure dependency is enabled
  modules.dependency-module.enable = true;

  # Then use it
  other-config = {
    depends-on = config.modules.dependency-module.value;
  };
};
```

## Home-Manager Module Checklist

- [ ] Module namespace decided: `modules.{category}.{name}`
- [ ] Directory created: `home/modules/modules/{category}/{name}/`
- [ ] File created: `home/modules/modules/{category}/{name}/default.nix`
- [ ] Options defined:
  - [ ] `enable` (boolean)
  - [ ] `package` (package reference)
  - [ ] Custom options as needed
- [ ] Configuration implemented:
  - [ ] Uses `cfg.enable` wrapper
  - [ ] References `cfg.package` with `getExe`
  - [ ] Custom settings applied correctly
- [ ] All option types valid (str, bool, path, attrs, listOf, etc.)
- [ ] Module uses `lib` functions from inherit statement
- [ ] Syntax verified with `nix flake check`
- [ ] Formatted with `pre-commit run -a`
- [ ] Staged in git: `git add home/modules/modules/{category}/{name}/`
- [ ] Optional: Role aggregator updated
- [ ] Optional: Documentation added to this module's purpose

## Module Structure Best Practices

### Keep Modules Focused

✅ **Good:** One module = one tool or feature
❌ **Bad:** Mixing unrelated configurations in one module

### Use Descriptive Option Names

✅ **Good:** `enablePluginSupport`, `shellType`, `apiKey`
❌ **Bad:** `enable2`, `shell`, `key`

### Provide Sensible Defaults

✅ **Good:** `default = "zsh"` (common choice)
❌ **Bad:** `default = ""` (ambiguous)

### Document Custom Options

Every custom option should have a description:

```nix
customOption = mkOption {
  type = types.str;
  default = "value";
  description = "Clear explanation of what this controls";
};
```

### Use mkIf for Conditionals

```nix
# Good: Config only applies when enabled
config = mkIf cfg.enable { ... };

# Avoid: Redundant checks
config = {
  something = if cfg.enable then value else null;
};
```

## Troubleshooting

**"option does not exist" error:**

- Check namespace spelling: `modules.{category}.{name}`
- Verify directory structure matches option path
- Ensure `default.nix` is in correct location
- Run `git add` on new module directory

**Module not appearing in config:**

- Check `home/modules/modules/` auto-discovery
- Modules must be in exactly: `home/modules/modules/{category}/{name}/`
- Must be staged in git for flake to see them
- **DO NOT run `nix flake update`** - unnecessary and can introduce upstream
  changes that complicate your work

**"inherit (lib) mkOption ... is not a function":**

- Check that `lib` is imported correctly in inherit statement
- Verify syntax: `inherit (lib) mkEnableOption mkOption mkIf ...;`
- Check for typos in function names

**Settings not applying:**

- Verify module is enabled: `cfg.enable` should be true
- Check that config is wrapped in `mkIf cfg.enable { ... }`
- Verify referenced config paths are correct
- Test with explicit value: `echo ${config.modules.category.name.option}`

## Next Steps

1. **Test module in home config:** `make hm/generate` or `make hm/apply`
2. **Update role if needed:** Add to `roles.{role}` for user control
3. **Document usage:** Add examples to module or README
4. **Create test config:** Test enabling/disabling and option changes

## Quick Reference: Common lib Functions

```nix
mkEnableOption "description"                # Boolean on/off
mkPackageOption pkgs "name" {}             # Package reference
mkOption {type = types.str; ...}           # String
mkOption {type = types.bool; ...}          # Boolean
mkOption {type = types.int; ...}           # Integer
mkOption {type = types.path; ...}          # File path
mkOption {type = types.attrs; ...}         # Nested config
mkOption {type = types.listOf types.str}   # List of strings
mkIf condition { ... }                     # Conditional config
getExe package                              # Get binary path
lib.foldl' fn init list                     # Map/reduce operation
```
