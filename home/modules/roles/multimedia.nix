{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.multimedia;
in {
  options.roles.desktop.multimedia = {
    enable = mkEnableOption "desktop.multimedia";
  };

  config = mkIf cfg.enable {
    services.spotifyd.enable = true;
    programs.ncspot.enable = true;
  };
}
