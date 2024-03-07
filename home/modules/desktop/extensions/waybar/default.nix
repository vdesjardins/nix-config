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

      settings = {
        mainBar = {
          ipc = true;
          layer = "top";
          position = "bottom";
          height = 40;
          modules-left = ["sway/workspaces" "sway/mode"];
          modules-center = ["cpu" "memory" "disk" "temperature" "tray"];
          modules-right = ["idle_inhibitor" "backlight" "network" "wireplumber" "battery" "custom/date" "clock"];

          "sway/workspaces" = {
            all-outputs = true;
            format = "{icon}";
            format-icons = {
              "1" = "󰋜";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "7" = "";
              "8" = "";
              "9" = "";
              "10" = "";
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

          "custom/date" = {
            "format" = "󰸗 {}";
            "interval" = 3600;
            "exec" = ''date +"%a %d"'';
          };

          "cpu" = {
            format = "{usage}% ";
            tooltip = false;
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

    wayland.windowManager.sway = {
      config.bars = [{command = "${pkgs.waybar}/bin/waybar";}];
    };
  };
}
