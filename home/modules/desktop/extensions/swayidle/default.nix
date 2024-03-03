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
          timeout = 300;
          command = "${pkgs.swaylock-effects}/bin/swaylock --fade-in 0.2 --clock --indicator-radius 100 --screenshots --effect-blur 5x7 --indicator --indicator-radius 100 indicator-thickness 7 --effect-vignette 0.5:0.5 --ring-color bb00cc --key-hl-color 880033 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --grace 2";
        }
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
