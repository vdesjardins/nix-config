{pkgs, ...}: {
  imports = [
    ../../../services/window-manager/i3
    ../../../programs/rofi
  ];
}
