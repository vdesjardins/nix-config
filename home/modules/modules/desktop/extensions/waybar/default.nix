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
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";
  pwvucontrol = lib.getExe pkgs.pwvucontrol;
  mkBtopCommand = name: sortBy: let
    launcher = pkgs.writeShellScript "waybar-btop-${name}" ''
      tmpconf="$(mktemp)"
      trap 'rm -f "$tmpconf"' EXIT
      if [ -f "$HOME/.config/btop/btop.conf" ]; then
        grep -vE '^[[:space:]]*(proc_sorting|proc_reversed)[[:space:]]*=' "$HOME/.config/btop/btop.conf" > "$tmpconf" || true
      fi
      printf 'proc_sorting = "%s"\nproc_reversed = False\n' ${lib.escapeShellArg sortBy} >> "$tmpconf"
      exec ${lib.getExe pkgs.btop} -c "$tmpconf"
    '';
  in "${lib.getExe pkgs.ghostty} --class=org.my.btop -e ${launcher}";
  btopCpuCommand = mkBtopCommand "cpu" "cpu lazy";
  btopMemCommand = mkBtopCommand "memory" "memory";
  thunar = lib.getExe pkgs.thunar;
  printerPython = pkgs.python3.withPackages (ps: [ps.pycups]);
  printerStatus = pkgs.writeShellScript "waybar-printer-status" ''
    exec ${lib.getExe printerPython} ${./printer-status.py} ${lib.escapeShellArg cfg.printer.name}
  '';
in {
  options.modules.desktop.extensions.waybar = {
    enable = mkEnableOption "waybar";

    printer = {
      enable = mkEnableOption "local CUPS printer status and queued documents";
      name = mkOption {
        type = str;
        default = "";
        description = "CUPS queue name; an empty string uses the default printer";
      };
    };

    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      inherit (cfg) enable;

      systemd = {
        enable = true;
        targets = ["graphical-session.target"];
      };

      settings = {
        mainBar = {
          ipc = true;
          layer = "top";
          position = "bottom";
          height = 40;
          fixed-center = true;
          modules-left = ["sway/workspaces" "sway/mode" "hyprland/workspaces" "hyprland/mode" "niri/workspaces"];
          modules-center = ["cpu" "memory" "disk" "temperature" "idle_inhibitor" "tray" "gamemode"];
          modules-right =
            ["backlight" "network"]
            ++ lib.optional cfg.printer.enable "custom/printer"
            ++ ["wireplumber" "wireplumber#source" "battery" "custom/date" "clock" "custom/utc"];

          "custom/printer" = mkIf cfg.printer.enable {
            exec = toString printerStatus;
            return-type = "json";
            format = " {}";
            interval = 5;
            tooltip = true;
            on-click =
              if config.programs.firefox.enable
              then "${lib.getExe config.programs.firefox.finalPackage} --new-window http://localhost:631/jobs/"
              else "${lib.getExe' pkgs.xdg-utils "xdg-open"} http://localhost:631/jobs/";
          };

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

          "niri/workspaces" = {
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
            on-click = btopCpuCommand;
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
            on-click = btopMemCommand;
          };

          "disk" = {
            format = "{percentage_used}% ";
            on-click = thunar;
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
            max-volume = 100;
            on-click = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            menu = "on-click-right";
            menu-file = "${./wireplumber-menu.xml}";
            menu-actions = {
              mute-sink = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
              mute-source = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              vol-up = "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
              vol-down = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              vol-25 = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 25%";
              vol-50 = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 50%";
              vol-75 = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 75%";
              vol-100 = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 100%";
              mixer = pwvucontrol;
            };
          };

          "wireplumber#source" = {
            node-type = "Audio/Source";
            format = "";
            format-muted = "";
            tooltip-format = "Mic: {volume}% ({node_name})";
            on-click = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            on-click-right = pwvucontrol;
            scroll-step = 5;
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
