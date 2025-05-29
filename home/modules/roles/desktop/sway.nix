{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.sway;

  wallpapersPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";

  wallpaperChooser = pkgs.writeShellScript "random-wallpaper" ''
    ${pkgs.findutils}/bin/find -L ${wallpapersPath} -type f | ${pkgs.coreutils}/bin/shuf -n 1
  '';

  lockerCommand = pkgs.writeShellScript "lock-random-wallpaper" ''
    ${config.programs.swaylock.package}/bin/swaylock -f --image `${wallpaperChooser}`
  '';
in {
  options.roles.desktop.sway = {
    enable = mkEnableOption "desktop.sway";
  };

  config = mkIf cfg.enable {
    roles.desktop.gtk.enable = true;
    roles.desktop.qt.enable = true;

    modules.desktop.window-managers.sway = {
      enable = true;
      inherit wallpaperChooser lockerCommand;
    };

    modules.desktop.extensions = {
      dconf.enable = true;
      dunst.enable = true;
      waybar.enable = true;
      rofi.enable = true;
      rofi.package = pkgs.rofi-wayland;
      swaylock.enable = true;
      swayidle = {
        enable = true;
        inherit lockerCommand;
      };
      xdg-portal.enable = true;
    };

    services.cliphist.enable = true;
  };
}
