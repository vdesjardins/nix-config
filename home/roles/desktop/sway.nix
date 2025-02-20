{
  config,
  pkgs,
  ...
}: let
  wallpapersPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";

  wallpaperChooser = pkgs.writeShellScript "random-wallpaper" ''
    ${pkgs.findutils}/bin/find -L ${wallpapersPath} -type f | ${pkgs.coreutils}/bin/shuf -n 1
  '';

  lockerCommand = pkgs.writeShellScript "lock-random-wallpaper" ''
    ${config.programs.swaylock.package}/bin/swaylock -f --image `${wallpaperChooser}`
  '';
in {
  imports = [
    ./gtk.nix
    ./qt.nix
  ];

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
}
