{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.nix-index;
in {
  options.modules.shell.tools.nix-index = {
    enable = mkEnableOption "nix-index";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [comma];

    programs.nix-index = {
      inherit (cfg) enable;

      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
