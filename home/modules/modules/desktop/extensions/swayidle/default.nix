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
          command = builtins.toString (
            pkgs.writeShellScript "swayidle-timeout-command"
            ''
              ${pkgs.sway}/bin/swaymsg "output * dpms off" || true
              ${pkgs.hyprland}/bin/hyprctl dispatch dpms off || true
              ${pkgs.niri}/bin/niri msg action power-off-monitors || true
            ''
          );
          resumeCommand = builtins.toString (
            pkgs.writeShellScript "swayidle-resume-command"
            ''
              ${pkgs.sway}/bin/swaymsg "output * dpms on" || true
              ${pkgs.hyprland}/bin/hyprctl dispatch dpms on || true
            ''
          );
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
