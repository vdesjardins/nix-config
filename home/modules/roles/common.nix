{
  config,
  my-packages,
  pkgs,
  lib,
  ...
}: let
  font = "Fira Code";
  font-italic = "Maple Mono Italic";
  font-bold = "Fira Code Bold";
  font-bold-italic = "Maple Mono Bold Italic";

  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.common;
in {
  options.roles.common = {
    enable = mkEnableOption "common";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.home-manager.enable = true;

    xdg.enable = true;
    xdg.mimeApps.enable = pkgs.stdenv.isLinux;

    home.enableNixpkgsReleaseCheck = false;

    # fonts and colors
    roles.desktop.gtk = {
      inherit font;
      themePackage = pkgs.tokyonight-gtk-theme;
      themeName = "Tokyonight-Dark";
      colorScheme = "dark";
      iconPackage = pkgs.papirus-icon-theme;
      iconName = "Papirus-Dark";
    };

    modules = {
      desktop = {
        terminal = {
          alacritty.font = font;
          wezterm = {
            font = "Fira Code";
            font-italic = "Maple Mono";
            color-scheme = "tokyonight_night";
          };
          ghostty = {
            inherit font font-italic font-bold font-bold-italic;
            theme = "TokyoNight Night";
          };
        };

        tools = {
          zathura.font = "${font} 12";
          imv.font = "${font}:12";
        };

        editors.nixvim = {
          colorschemes.tokyonight = {
            enable = true;
            settings = {
              style = "night";
            };
          };
        };

        extensions = {
          rofi.font = "${font} 12";
          dunst = {
            inherit font;
            settings = {
              # from https://github.com/folke/tokyonight.nvim/blob/main/extras/dunst/tokyonight_night.dunstrc
              urgency_low = {
                background = "#16161e";
                foreground = "#c0caf5";
                frame_color = "#c0caf5";
              };

              urgency_normal = {
                background = "#1a1b26";
                foreground = "#c0caf5";
                frame_color = "#c0caf5";
              };

              urgency_critical = {
                background = "#292e42";
                foreground = "#db4b4b";
                frame_color = "#db4b4b";
              };
            };
          };
          swaylock.font = font;
          waybar.font = font;
        };

        window-managers = {
          sway.font = font;
        };
      };

      shell.tools = {
        btop.color-scheme = "tokio-night";
        fzf.color-scheme = "${my-packages.tinted-fzf}/share/tinted-fzf/bash/base16-tokyo-night-dark.config";
        bat.color-scheme = "${my-packages.colorscheme-tokyonight}/share/themes/tokyonight/extras/sublime/tokyonight_night.tmTheme";
        git = {
          delta = {
            # [theme] tokyonight-night
            # from https://github.com/folke/tokyonight.nvim/blob/main/extras/delta/tokyonight_night.gitconfig
            minus-style = "syntax #37222c";
            minus-non-emph-style = "syntax #37222c";
            minus-emph-style = "syntax #713137";
            minus-empty-line-marker-style = "syntax #37222c";
            line-numbers-minus-style = "#914c54";
            plus-style = "syntax #20303b";
            plus-non-emph-style = "syntax #20303b";
            plus-emph-style = "syntax #2c5a66";
            plus-empty-line-marker-style = "syntax #20303b";
            line-numbers-plus-style = "#449dab";
            line-numbers-zero-style = "#3b4261";
          };
        };
      };
    };
  };
}
