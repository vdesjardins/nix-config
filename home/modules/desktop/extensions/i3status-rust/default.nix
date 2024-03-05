{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum str;

  cfg = config.modules.desktop.extensions.i3status-rust;
in {
  options.modules.desktop.extensions.i3status-rust = {
    enable = mkEnableOption "3status-rust";

    font = mkOption {
      type = str;
      default = "";
    };

    keyboardCommand = mkOption {
      type = enum ["setxkbmap" "localbus" "kbddbus" "sway"];
      default = "setxkbmap";
    };
  };

  config = mkIf cfg.enable {
    programs.i3status-rust = {
      inherit (cfg) enable;

      bars = {
        default = {
          theme = "ctp-mocha";
          icons = "awesome6";

          blocks = [
            {
              block = "music";
              format = " $icon {$combo.str(max_w:25,rot_interval:0.5) $prev $play $next |}";
            }
            {
              block = "disk_space";
              info_type = "available";
              interval = 60;
              path = "/";
              format = "$icon root: $available.eng(w:2)";
            }
            {
              block = "memory";
              format = "$icon $mem_total_used_percents.eng(w:2)";
              format_alt = "$icon_swap $swap_used_percents.eng(w:2)";
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "load";
              format = "$icon $1m";
              interval = 1;
            }
            {
              block = "keyboard_layout";
              interval = 2;
              driver = cfg.keyboardCommand;
            }
            {
              block = "sound";
              step_width = 2;
            }
            {
              block = "time";
              format = "UTC $timestamp.datetime(f:'%H')";
              timezone = "Etc/UTC";
              interval = 1;
            }
            {
              block = "time";
              format = "$icon $timestamp.datetime(f:'%a %d/%m %R')";
              interval = 1;
            }
          ];
        };
      };
    };

    wayland.windowManager.sway = {
      config.bars = [
        {
          colors = {
            background = "#1c1c22";
            focusedWorkspace = {
              border = "#7592af";
              background = "#2e3440";
              text = "#ffffff";
            };
          };

          fonts = {
            names = [cfg.font];
            size = 12.0;
          };

          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-default.toml";
        }
      ];
    };
  };
}
