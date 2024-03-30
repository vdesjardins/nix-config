{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  modules.desktop.window-managers.sway = {
    enable = true;
    wallpapersPath = mkDefault "${config.home.homeDirectory}/Pictures/Wallpapers/";
  };

  modules.desktop.extensions = {
    dunst.enable = true;
    waybar.enable = true;
    rofi.enable = true;
    rofi.package = pkgs.rofi-wayland;
    swaylock.enable = true;
    swayidle.enable = true;
    xdg-portal.enable = true;
  };

  services.cliphist.enable = true;
  gtk.enable = true;
}
