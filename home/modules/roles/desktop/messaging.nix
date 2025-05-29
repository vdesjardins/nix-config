{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.messaging;
in {
  options.roles.desktop.messaging = {
    enable = mkEnableOption "desktop.messaging";
  };

  config = mkIf cfg.enable {
    modules.desktop.messaging.signal-desktop.enable = true;
  };
}
