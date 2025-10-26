{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.gaming;
in {
  options.roles.desktop.gaming = {
    enable = mkEnableOption "desktop.gaming";
  };

  config = mkIf cfg.enable {
    modules.desktop.gaming = {
      lutris.enable = true;
      steam.enable = true;
      wine.enable = true;
      dolphin.enable = false;
    };
  };
}
