{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.multimedia;
in {
  options.roles.multimedia = {
    enable = mkEnableOption "desktop.multimedia";
  };

  config = mkIf cfg.enable {
    services.spotifyd.enable = true;
    programs.ncspot.enable = true;
  };
}
