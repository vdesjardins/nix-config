{pkgs, ...}: {
  imports = [
    ../../../services/window-manager/sway
    ../../../programs/swaylock
    ../../../programs/rofi
  ];

  programs.rofi.package = pkgs.rofi-wayland;
}
