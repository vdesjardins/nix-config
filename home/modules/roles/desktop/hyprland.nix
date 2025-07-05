{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.hyprland;

  wallpapersPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";
in {
  options.roles.desktop.hyprland = {
    enable = mkEnableOption "desktop.hyprland";
  };

  config = mkIf cfg.enable {
    modules.desktop.window-managers.hyprland = {
      enable = true;
      inherit wallpapersPath;
    };
  };
}
