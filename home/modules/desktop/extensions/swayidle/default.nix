{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) package;

  cfg = config.modules.desktop.extensions.swayidle;
in {
  options.modules.desktop.extensions.swayidle = {
    enable = mkEnableOption "swayidle";
    lockerCommand = mkOption {
      type = package;
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
          timeout = 300;
          command = "${cfg.lockerCommand}";
        }
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
