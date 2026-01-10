{
  config,
  pkgs,
  lib,
  stdenv,
  ...
}: let
  inherit (lib) mkIf mkOption types optionals optional;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.languages;
in {
  options.roles.dev.languages = {
    enable = mkEnableOption "development languages (bash, go, python, js, lua, nix, rust, terraform, zig, cue, kcl)";
    bash.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Bash (bash, bats)";
    };
    go.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Go (go, gopls, delve, gokart)";
    };
    python.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Python (poetry)";
    };
    js.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable JavaScript (node2nix)";
    };
    lua.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Lua (lua5_3)";
    };
    nix.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Nix (nixpkgs-fmt, nix-bisect, nix-init, nix-inspect, nix-tree, nix-prefetch, nurl, nvd, nix-output-monitor)";
    };
    rust.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Rust (rustc, cargo, crate2nix)";
    };
    terraform.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Terraform (hcledit, inframap, terraformer)";
    };
    zig.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Zig (zig)";
    };
    cue.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Cue (cue, cuetools)";
    };
    kcl.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable KCL (kcl-language-server) - now built from GitHub main branch with LSP using native vim.lsp.config API (neovim 0.11+)";
    };
    debugging.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable debugging tools (gdb, gdbgui, binutils, xxd, nix-function-calls)";
    };
    profiling.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable profiling tools (tracy)";
    };
    common.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable common language tools (asdf-vm)";
    };
  };

  config = mkIf cfg.enable {
    programs.bash.enable = cfg.bash.enable;

    # Terraform module
    modules.shell.tools.terraform.enable = cfg.terraform.enable;

    # Debugging tools modules
    modules.shell.tools.nix-function-calls.enable = cfg.debugging.enable;

    home.packages = with pkgs;
      (optionals cfg.bash.enable [bats])
      ++ (optionals cfg.go.enable [
        delve
        go
        gopls
        gokart
      ])
      ++ (optionals cfg.python.enable [poetry])
      ++ (optionals cfg.js.enable [nodePackages.node2nix])
      ++ (optionals cfg.lua.enable [lua5_3])
      ++ (optionals cfg.nix.enable [
        nixpkgs-fmt
        nix-bisect
        nix-diff
        nix-init
        nix-inspect
        nix-tree
        nix-prefetch
        nix-prefetch-git
        nix-output-monitor
        nurl
        nvd
      ])
      ++ (optionals cfg.rust.enable [crate2nix cargo rustc])
      ++ (optionals cfg.terraform.enable [
        hcledit
        inframap
        terraformer
      ])
      ++ (optionals cfg.zig.enable [zig])
      ++ (optionals cfg.cue.enable [
        cue
        cuetools
      ])
      ++ (optionals cfg.kcl.enable [
        kcl
        kcl-language-server
      ])
      ++ (optionals cfg.debugging.enable [
          binutils
          xxd
        ]
        ++ optionals pkgs.stdenv.isLinux [pkgs.gdbgui])
      ++ (optionals cfg.profiling.enable [tracy])
      ++ [asdf-vm];
  };
}
