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
  modules.desktop.terminal.wezterm.font = font;
  modules.desktop.terminal.alacritty.font = font;

  modules.desktop.tools.zathura.font = "${font} 12";
  modules.desktop.tools.imv.font = "${font}:12";
  modules.desktop.extensions.rofi.font = "${font} 12";
  modules.desktop.extensions.dunst.font = font;

  modules.desktop.window-managers.i3.font = font;

  modules.desktop.extensions.swaylock.font = font;
  modules.desktop.window-managers.sway.font = font;
}
