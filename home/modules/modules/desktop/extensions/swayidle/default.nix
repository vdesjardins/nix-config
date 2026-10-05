{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) int str;
  inherit (builtins) toString;

  cfg = config.modules.desktop.extensions.swayidle;

  monitorPower = pkgs.writeShellScriptBin "monitor-power" ''
    set -eu
    case "$1" in
      on|off) ;;
      *) echo "Usage: monitor-power on|off" >&2; exit 2 ;;
    esac

    if [[ -n "''${NIRI_SOCKET:-}" ]]; then
      exec ${pkgs.niri}/bin/niri msg action "power-$1-monitors"
    elif [[ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
      exec ${pkgs.hyprland}/bin/hyprctl dispatch dpms "$1"
    elif [[ -n "''${SWAYSOCK:-}" ]]; then
      exec ${pkgs.sway}/bin/swaymsg "output * power $1"
    else
      echo "No supported Wayland compositor found" >&2
      exit 1
    fi
  '';
in {
  options.modules.desktop.extensions.swayidle = {
    enable = mkEnableOption "swayidle";
    wallpapersPath = mkOption {
      type = str;
    };
    notifyTimeout = mkOption {
      type = int;
      default = 5 * 60;
    };
    lockTimeout = mkOption {
      type = int;
      default = 7 * 60;
    };
    dpmsTimeout = mkOption {
      type = int;
      default = 10 * 60;
    };
  };

  config = mkIf cfg.enable (let
    lockerCommand = "${config.home.profileDirectory}/bin/lock-screen";
  in {
    home.packages = [monitorPower];

    services.swayidle = {
      inherit (cfg) enable;

      events.before-sleep = "${lockerCommand}";

      timeouts = [
        {
          timeout = cfg.notifyTimeout;
          command = let
            delta = toString (cfg.lockTimeout - cfg.notifyTimeout);
          in
            builtins.toString (
              pkgs.writeShellScript "swayidle-notify-command"
              ''
                ${pkgs.libnotify}/bin/notify-send "Going to sleep in ${delta} seconds" -t 5000
              ''
            );
        }
        {
          timeout = cfg.lockTimeout;
          command = "${lockerCommand}";
        }
        {
          timeout = cfg.dpmsTimeout;
          command = "${monitorPower}/bin/monitor-power off";
          resumeCommand = "${monitorPower}/bin/monitor-power on";
        }
      ];
    };

    wayland.windowManager.hyprland = {
      settings.bind = [
        # lock session
        "$mod SHIFT, X, exec, ${lockerCommand}"
      ];
    };

    wayland.windowManager.sway = {
      config.keybindings = lib.mkOptionDefault {
        # lock screen
        "Mod4+Shift+x" = "exec --no-startup-id ${lockerCommand}";
      };
    };
  });
}
