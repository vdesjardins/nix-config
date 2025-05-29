{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.viewers;
in {
  options.roles.desktop.viewers = {
    enable = mkEnableOption "desktop.viewers";
  };

  config = mkIf cfg.enable {
    modules.desktop.tools.zathura.enable = true;
    modules.desktop.tools.imv.enable = true;
  };
}
