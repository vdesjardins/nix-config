{pkgs, ...}: {
  imports = [
    ../../../services/window-manager/sway
    ../../../programs/swaylock
    ../../../programs/wofi
  ];
}
