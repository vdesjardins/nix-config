{pkgs, ...}: {
  services.window-manager.sway.enable = true;
  programs.swaylock.enable = true;
  programs.rofi.enable = true;

  programs.rofi.package = pkgs.rofi-wayland;
  programs.i3status-rust.keyboardCommand = "sway";
  services.dunst.enable = true;

  xdg.portal.enable = true;

  services.cliphist.enable = true;
}
