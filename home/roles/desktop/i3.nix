{pkgs, ...}: {
  modules.desktop.window-managers.i3.enable = true;

  modules.desktop.extensions = {
    dconf.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    i3status-rust.enable = true;
  };
}
