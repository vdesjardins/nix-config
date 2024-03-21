{pkgs, ...}: {
  modules.desktop.window-managers.i3.enable = true;

  modules.desktop.extensions = {
    rofi.enable = true;
    dunst.enable = true;
    i3status-rust.enable = true;
  };
}
