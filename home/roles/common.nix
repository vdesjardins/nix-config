{lib, ...}:
with lib; let
  font = "MonaspiceRn Nerd Font";
in {
  home.sessionVariables = {
    EDITOR = "vi";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  home.enableNixpkgsReleaseCheck = false;

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
  programs.rofi.font = "${font} 12";
  services.dunst.settings.global.font = font;

  # i3
  services.window-manager.i3.font = font;

  # Sway
  programs.swaylock.settings.font = font;
  services.window-manager.sway.font = font;
}