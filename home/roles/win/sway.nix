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
    wallpaperPath = mkDefault "${config.home.homeDirectory}/Pictures/Wallpapers/wallhaven.jpg";
  };

  modules.desktop.extensions = {
    dunst.enable = true;
    i3status-rust.enable = true;
    i3status-rust.keyboardCommand = "sway";
    rofi.enable = true;
    rofi.package = pkgs.rofi-wayland;
    swaylock.enable = true;
    swayidle.enable = true;
    xdg-portal.enable = true;
  };

  services.cliphist.enable = true;
  gtk.enable = true;
}
