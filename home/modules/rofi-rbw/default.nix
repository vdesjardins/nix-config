{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.rofi-rbw;
in {
  options.programs.rofi-rbw = {
    enable = mkEnableOption "rofi-rbw";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-rbw
    ];
  };
}
