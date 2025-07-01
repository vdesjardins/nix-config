{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.tools.spacedrive;
in {
  options.modules.desktop.tools.spacedrive = {
    enable = mkEnableOption "spacedrive";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [spacedrive];
  };
}
