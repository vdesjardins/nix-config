{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.productivity;
in {
  options.roles.desktop.productivity = {
    enable = mkEnableOption "desktop.productivity";
  };

  config = mkIf cfg.enable {
    modules.desktop.tools.logseq.enable = true;
    modules.desktop.tools.spacedrive.enable = true;
  };
}
