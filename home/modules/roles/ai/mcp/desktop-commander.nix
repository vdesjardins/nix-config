{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.desktop-commander;
in {
  options.roles.ai.mcp.desktop-commander = {
    enable = mkEnableOption "desktop-commander";
  };

  config = mkIf cfg.enable {
    modules.mcp.desktop-commander.enable = true;
  };
}
