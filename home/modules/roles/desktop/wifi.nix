{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.wifi;
in {
  options.roles.desktop.wifi = {
    enable = mkEnableOption "desktop.wifi";
  };

  config = mkIf cfg.enable {
    modules.services.wifi.enable = true;
  };
}
