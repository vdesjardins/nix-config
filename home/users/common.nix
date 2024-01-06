{lib, ...}:
with lib; let
  font = "Monaspace Radon";
in {
  home.sessionVariables = {
    EDITOR = "vi";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  home.stateVersion = "23.11";

  # font
  programs.wezterm.font = font;
  programs.alacritty.settings.font = {
    normal.family = font;
    bold.family = font;
    italic.family = font;
    bold_italic.family = font;
  };

  # tools
  programs.zathura.options.font = "${font} 12";
  programs.imv.settings.options.overlay_font = "${font}:12";
  programs.rofi.font = "pango:${font} 12";

  # i3
  services.window-manager.i3.font = font;

  # Sway
  programs.swaylock.settings.font = font;
  services.window-manager.sway.font = font;
}
