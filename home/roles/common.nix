{pkgs, ...}: let
  font = "MonaspiceRn Nerd Font";
in {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;

  home.enableNixpkgsReleaseCheck = false;

  # font
  modules.desktop = {
    terminal = {
      wezterm.font = font;
      alacritty.font = font;
    };

    tools = {
      zathura.font = "${font} 12";
      imv.font = "${font}:12";
    };

    extensions = {
      rofi.font = "${font} 12";
      dunst.font = font;
      swaylock.font = font;
      i3status-rust.font = font;
      waybar.font = font;
    };

    window-managers = {
      i3.font = font;
      sway.font = font;
    };
  };

  gtk = {
    theme = {
      name = "Tokyonight-Storm-B";
      package = pkgs.tokyo-night-gtk-theme;
    };
  };
}
