{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.extensions.rofi-rbw;
in {
  options.modules.desktop.extensions.rofi-rbw = {
    enable = mkEnableOption "rofi-rbw";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-rbw
    ];
  };
}
