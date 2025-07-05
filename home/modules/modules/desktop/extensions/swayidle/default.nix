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
    wallpaperChooser = pkgs.writeShellScript "random-wallpaper" ''
      ${pkgs.findutils}/bin/find -L ${cfg.wallpapersPath} -type f | ${pkgs.coreutils}/bin/shuf -n 1
    '';

    lockerCommand = pkgs.writeShellScript "lock-random-wallpaper" ''
      ${config.programs.swaylock.package}/bin/swaylock -f --image `${wallpaperChooser}`
    '';
  in {
    services.swayidle = {
      inherit (cfg) enable;

      events = [
        {
          event = "before-sleep";
          command = "${lockerCommand}";
        }
      ];

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
              ${pkgs.sway}/bin/swaymsg "output * dpms off"
              ${pkgs.hyprland}/bin/hyprctl dispatch dpms off
            ''
          );
          resumeCommand = builtins.toString (
            pkgs.writeShellScript "swayidle-resume-command"
            ''
              ${pkgs.sway}/bin/swaymsg "output * dpms on"
              ${pkgs.hyprland}/bin/hyprctl dispatch dpms on
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
