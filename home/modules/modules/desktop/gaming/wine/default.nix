{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.gaming.wine;
in {
  options.modules.desktop.gaming.wine = {
    enable = mkEnableOption "wine";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [wineWowPackages.staging winetricks];
  };
}
