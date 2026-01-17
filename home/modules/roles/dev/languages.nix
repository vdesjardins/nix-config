{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types optionals;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.languages;
in {
  options.roles.dev.languages = {
    enable = mkEnableOption "development languages";
    bash.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Bash";
    };
    nix.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Nix";
    };
    terraform.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Terraform";
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
  };

  config = mkIf cfg.enable {
    programs.bash.enable = cfg.bash.enable;

    # Terraform module
    modules.shell.tools.terraform.enable = cfg.terraform.enable;

    # Debugging tools modules
    modules.shell.tools.nix-function-calls.enable = cfg.debugging.enable;

    home.packages = with pkgs;
      (optionals cfg.nix.enable [
        nixpkgs-fmt
        nix-bisect
        nix-diff
        nix-init
        nix-inspect
      ])
      ++ (optionals cfg.debugging.enable [
          binutils
          xxd
        ]
        ++ optionals pkgs.stdenv.isLinux [pkgs.gdbgui])
      ++ (optionals cfg.profiling.enable [tracy]);
  };
}
