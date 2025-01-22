{pkgs, ...}: let
  font = "MonaspiceRn NF";
  font-italic = "MonaspiceRn NF Italic";
  font-bold = "MonaspiceRn NF Bold";
  font-bold-italic = "MonaspiceRn NF Bold Italic";
in {
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.mimeApps.enable = true;

  home.enableNixpkgsReleaseCheck = false;

  # font
  modules = {
    desktop = {
      terminal = {
        alacritty.font = font;
        wezterm = {
          font = font;
          color-scheme = "tokyonight_night";
        };
        ghostty = {
          inherit font font-italic font-bold font-bold-italic;
          theme = "tokyonight_night";
        };
      };

      tools = {
        zathura.font = "${font} 12";
        imv.font = "${font}:12";
      };

      extensions = {
        dconf = {
          font = font;
          gtk-theme = "Tokyonight-Night-B";
          color-scheme = "prefer-dark";
          icon-theme = "Papirus-Dark";
        };
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

    shell.tools = {
      btop.color-scheme = "tokio-night";
      fzf.color-scheme = "${pkgs.tinted-fzf}/share/tinted-fzf/bash/base16-tokyo-night-dark.config";
      bat.color-scheme = "${pkgs.colorscheme-tokyonight}/share/themes/tokyonight/extras/sublime/tokyonight_night.tmTheme";
    };
  };

  gtk = {
    theme = {
      name = "Tokyonight-Night-B";
      package = pkgs.tokyonight-gtk-theme;
    };
  };
}
