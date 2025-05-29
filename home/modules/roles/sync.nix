{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.sync;
in {
  options.roles.sync = {
    enable = mkEnableOption "sync";
  };

  config = mkIf cfg.enable {
    modules.services.syncthing.enable = true;
  };
}
