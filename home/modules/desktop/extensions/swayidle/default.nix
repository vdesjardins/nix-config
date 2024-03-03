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

      timeouts = [
        {
          timeout = 120;
          command = "${pkgs.swaylock-effects}/bin/swaylock --fade-in 2 --clock --indicator-radius 100";
        }
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
