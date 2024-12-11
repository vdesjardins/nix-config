{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) package int;
  inherit (builtins) toString;

  cfg = config.modules.desktop.extensions.swayidle;
in {
  options.modules.desktop.extensions.swayidle = {
    enable = mkEnableOption "swayidle";
    lockerCommand = mkOption {
      type = package;
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

  config = mkIf cfg.enable {
    services.swayidle = {
      inherit (cfg) enable;

      events = [
        {
          event = "before-sleep";
          command = "${cfg.lockerCommand}";
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
          command = "${cfg.lockerCommand}";
        }
        {
          timeout = cfg.dpmsTimeout;
          command = builtins.toString (
            pkgs.writeShellScript "swayidle-timeout-command"
            ''
              ${pkgs.sway}/bin/swaymsg "output * dpms off"
            ''
          );
          resumeCommand = builtins.toString (
            pkgs.writeShellScript "swayidle-resume-command"
            ''
              ${pkgs.sway}/bin/swaymsg "output * dpms on"
            ''
          );
        }
      ];
    };
  };
}
