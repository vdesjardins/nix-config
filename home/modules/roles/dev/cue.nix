{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.cue;
in {
  options.roles.dev.cue = {
    enable = mkEnableOption "dev.cue";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cue
      cuetools
    ];
  };
}
