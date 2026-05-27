{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.extensions.waybar;
in {
  options.modules.desktop.extensions.waybar = {
    enable = mkEnableOption "waybar";

    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      inherit (cfg) enable;

      systemd = {
        enable = true;
        targets = ["hyprland-session.target"];
      };

      settings = {
        mainBar = {
          ipc = true;
          layer = "top";
          position = "bottom";
          height = 40;
          modules-left = ["sway/workspaces" "sway/mode" "hyprland/workspaces" "hyprland/mode"];
          modules-center = ["cpu" "memory" "disk" "temperature" "idle_inhibitor" "gamemode" "tray"];
          modules-right = ["backlight" "network" "wireplumber" "battery" "custom/date" "clock" "custom/utc"];

          "sway/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = "󰋜";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "7" = "";
              "8" = "";
              "9" = "";
              "10" = "";
              default = "";
            };
          };

          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              "1" = "󰋜";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "7" = "";
              "8" = "";
              "9" = "";
              "10" = "";
              default = "";
            };
          };

          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          "tray" = {
            spacing = 10;
          };

          "clock" = {
            format = "󰅐  {:%H:%M:%S}";
            format-alt = "{:%a %b %d, %Y}";
            interval = 1;
            tooltip-format = "{:%a %b %d, %Y | %H:%M:%S}";
          };

          "custom/utc" = {
            format = "UTC {}";
            "exec" = ''date -u +"%H"'';
            interval = 1;
          };

          "custom/date" = {
            "format" = "󰸗 {}";
            "interval" = 3600;
            "exec" = ''date +"%a %d"'';
          };

          "cpu" = {
            format = "{usage}% ";
            tooltip = false;
          };

          "gamemode" = {
            "format" = "{glyph}";
            "format-alt" = "{glyph} {count}";
            "glyph" = "";
            "hide-not-running" = true;
            "use-icon" = true;
            "icon-name" = "input-gaming-symbolic";
            "tooltip" = true;
            "tooltip-format" = "Games running {count}";
          };

          "memory" = {
            format = "{}% ";
          };

          "disk" = {
            format = "{percentage_used}% ";
          };

          "temperature" = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" "" "" ""];
          };

          "backlight" = {
            format = "{percent}% ";
          };

          "battery" = {
            states = {
              warning = 30;
              critical = 10;
            };
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
          };

          "network" = {
            format-wifi = "  {essid} ({signalStrength}%)";
            format-ethernet = "  {ifname}: {ipaddr}/{cidr}";
            format-disconnected = "⚠ Disconnected";
          };

          "wireplumber" = {
            format = "{volume}% {icon}";
            format-muted = "󰖁 Muted";
            format-icons = ["" "" ""];
          };
        };
      };

      style = ./style.css;
    };

    systemd.user.services.waybar = {
      Service.Restart = "on-failure";
      Service.RestartSec = "2s";
    };

    wayland.windowManager.sway = {
      config.bars = [{command = "${pkgs.waybar}/bin/waybar";}];
    };
  };
}
