{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.extensions.swayidle;
in {
  options.modules.desktop.extensions.swayidle = {
    enable = mkEnableOption "swayidle";
  };

  config = mkIf cfg.enable {
    services.swayidle = {
      inherit (cfg) enable;

      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock-effects}/bin/swaylock --daemonize";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock-effects}/bin/swaylock --daemonize --grace 0";
        }
        {
          event = "unlock";
          command = "pkill -SIGUSR1 swaylock";
        }
        {
          event = "after-resume";
          command = "swaymsg \"output * dpms on\"";
        }
      ];

      timeouts = [
        {
          timeout = 1800;
          command = "${pkgs.swaylock-effects}/bin/swaylock --daemonize";
        }
        {
          timeout = 2000;
          command = "swaymsg \"output * dpms off\"";
          resumeCommand = "swaymsg \"output * dpms on\"";
        }
      ];
    };
  };
}
