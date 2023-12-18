{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;

    settings = {
      env = {TERM = "xterm-256color";};
      window = {
        dimensions = {
          columns = 100;
          lines = 85;
        };
        padding = {
          x = 0;
          y = 0;
        };
        dynamic_padding = false;
        decorations = "full";
        startup_mode = "Maximized";
        opacity = 1;
      };
      scrolling = {
        history = 0;
        multiplier = 3;
      };
      font = {
        normal = {
          style = "Regular";
        };
        bold = {
          style = "Bold";
        };
        italic = {
          style = "Italic";
        };
        bold_italic = {
          style = "Bold Italic";
        };
        size = 12;
        offset = {
          x = 0;
          y = 0;
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
      draw_bold_text_with_bright_colors = false;
      colors = {
        # [theme]
        # tokyonight storm https://github.com/folke/tokyonight.nvim/blob/main/extras/alacritty/tokyonight_storm.yml
        primary = {
          background = "0x24283b";
          foreground = "0xc0caf5";
        };
        cursor = {
          text = "0x000000";
          cursor = "0xffffff";
        };
        normal = {
          black = "0x1d202f";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xa9b1d6";
        };
        bright = {
          black = "0x414868";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xc0caf5";
        };

        indexed_colors = [
          {
            index = 16;
            color = "0xff9e64";
          }
          {
            index = 17;
            color = "0xdb4b4b";
          }
        ];
      };
      bell = {
        animation = "EaseOutExpo";
        color = "0xffffff";
        duration = 0;
      };
      key_bindings = [
        {
          key = "V";
          mods = "Command";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Command";
          action = "Copy";
        }
        {
          key = "Q";
          mods = "Command";
          action = "Quit";
        }
        {
          key = "N";
          mods = "Command";
          action = "SpawnNewInstance";
        }
        {
          key = "Return";
          mods = "Command";
          action = "ToggleFullscreen";
        }
        {
          key = "F";
          mods = "Alt";
          chars = "\\x1bf";
        }
        {
          key = "B";
          mods = "Alt";
          chars = "\\x1bb";
        }
        {
          key = "D";
          mods = "Alt";
          chars = "\\x1bd";
        }
        {
          key = "A";
          mods = "Alt";
          chars = "\\x1ba";
        }
        {
          key = "Period";
          mods = "Alt";
          chars = "\\x1b.";
        }
        {
          key = "Key6";
          mods = "Control";
          chars = "\\x1e";
        }
        {
          key = "Space";
          mods = "Control";
          chars = "\\x00";
        }
        {
          key = "Home";
          chars = "\\x1bOH";
          mode = "AppCursor";
        }
        {
          key = "Home";
          chars = "\\x1b[H";
          mode = "~AppCursor";
        }
        {
          key = "End";
          chars = "\\x1bOF";
          mode = "AppCursor";
        }
        {
          key = "End";
          chars = "\\x1b[F";
          mode = "~AppCursor";
        }
        {
          key = "Equals";
          mods = "Command";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Command";
          action = "DecreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Command|Shift";
          action = "ResetFontSize";
        }
        {
          key = "PageUp";
          mods = "Shift";
          chars = "\\x1b[5;2~";
        }
        {
          key = "PageUp";
          mods = "Control";
          chars = "\\x1b[5;5~";
        }
        {
          key = "PageUp";
          chars = "\\x1b[5~";
        }
        {
          key = "PageDown";
          mods = "Shift";
          chars = "\\x1b[6;2~";
        }
        {
          key = "PageDown";
          mods = "Control";
          chars = "\\x1b[6;5~";
        }
        {
          key = "PageDown";
          chars = "\\x1b[6~";
        }
        {
          key = "Left";
          mods = "Shift";
          chars = "\\x1b[1;2D";
        }
        {
          key = "Left";
          mods = "Control";
          chars = "\\x1b[1;5D";
        }
        {
          key = "Left";
          mods = "Alt";
          chars = "\\x1b[1;3D";
        }
        {
          key = "Left";
          chars = "\\x1b[D";
          mode = "~AppCursor";
        }
        {
          key = "Left";
          chars = "\\x1bOD";
          mode = "AppCursor";
        }
        {
          key = "Right";
          mods = "Shift";
          chars = "\\x1b[1;2C";
        }
        {
          key = "Right";
          mods = "Control";
          chars = "\\x1b[1;5C";
        }
        {
          key = "Right";
          mods = "Alt";
          chars = "\\x1b[1;3C";
        }
        {
          key = "Right";
          chars = "\\x1b[C";
          mode = "~AppCursor";
        }
        {
          key = "Right";
          chars = "\\x1bOC";
          mode = "AppCursor";
        }
        {
          key = "Up";
          mods = "Shift";
          chars = "\\x1b[1;2A";
        }
        {
          key = "Up";
          mods = "Control";
          chars = "\\x1b[1;5A";
        }
        {
          key = "Up";
          mods = "Alt";
          chars = "\\x1b[1;3A";
        }
        {
          key = "Up";
          chars = "\\x1b[A";
          mode = "~AppCursor";
        }
        {
          key = "Up";
          chars = "\\x1bOA";
          mode = "AppCursor";
        }
        {
          key = "Down";
          mods = "Shift";
          chars = "\\x1b[1;2B";
        }
        {
          key = "Down";
          mods = "Control";
          chars = "\\x1b[1;5B";
        }
        {
          key = "Down";
          mods = "Alt";
          chars = "\\x1b[1;3B";
        }
        {
          key = "Down";
          chars = "\\x1b[B";
          mode = "~AppCursor";
        }
        {
          key = "Down";
          chars = "\\x1bOB";
          mode = "AppCursor";
        }
        {
          key = "Tab";
          mods = "Shift";
          chars = "\\x1b[Z";
        }
        {
          key = "F1";
          chars = "\\x1bOP";
        }
        {
          key = "F2";
          chars = "\\x1bOQ";
        }
        {
          key = "F3";
          chars = "\\x1bOR";
        }
        {
          key = "F4";
          chars = "\\x1bOS";
        }
        {
          key = "F5";
          chars = "\\x1b[15~";
        }
        {
          key = "F6";
          chars = "\\x1b[17~";
        }
        {
          key = "F7";
          chars = "\\x1b[18~";
        }
        {
          key = "F8";
          chars = "\\x1b[19~";
        }
        {
          key = "F9";
          chars = "\\x1b[20~";
        }
        {
          key = "F10";
          chars = "\\x1b[21~";
        }
        {
          key = "F11";
          chars = "\\x1b[23~";
        }
        {
          key = "F12";
          chars = "\\x1b[24~";
        }
        {
          key = "Back";
          chars = "\\x7f";
        }
        {
          key = "Back";
          mods = "Alt";
          chars = "\\x1b\\x7f";
        }
        {
          key = "Insert";
          chars = "\\x1b[2~";
        }
        {
          key = "Delete";
          chars = "\\x1b[3~";
        }
      ];
      mouse = {
        double_click = {threshold = 300;};
        triple_click = {threshold = 300;};
        hide_when_typing = true;
      };
      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>";
        save_to_clipboard = true;
      };
      mouse_bindings = [
        {
          mouse = "Middle";
          action = "PasteSelection";
        }
      ];
      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };
      live_config_reload = true;
      debug = {
        render_timer = false;
        persistent_logging = false;
        log_level = "OFF";
        print_events = false;
        ref_test = false;
      };
    };
  };
}
