{pkgs, ...}: {
  modules.desktop.window-managers.sway.enable = true;

  modules.desktop.extensions = {
    dunst.enable = true;
    i3status-rust.enable = true;
    i3status-rust.keyboardCommand = "sway";
    rofi.enable = true;
    rofi.package = pkgs.rofi-wayland;
    swaylock.enable = true;
    xdg-portal.enable = true;
  };

  services.cliphist.enable = true;
}
