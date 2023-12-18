let
  font = "Monaspace Radon";
in {
  home.sessionVariables = {
    EDITOR = "vi";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  home.stateVersion = "21.05";

  # font
  programs.alacritty.settings.font = {
    normal.family = font;
    bold.family = font;
    italic.family = font;
    bold_italic.family = font;
  };

  programs.zathura.options.font = "${font} 10";
  programs.imv.settings.options.overlay_font = "${font}:12";

  # i3
  programs.rofi.font = "pango:${font} 10";
  services.window-manager.myI3.font = font;

  # Sway
  programs.swaylock.settings.font = font;
  programs.myWofi.font = font;
  services.window-manager.mySway.font = font;
}
