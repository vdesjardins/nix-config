{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.desktop-commander;
in {
  options.modules.mcp.desktop-commander = {
    enable = mkEnableOption "desktop-commander mcp server";

    package = mkPackageOption pkgs "desktop-commander-mcp" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.desktop-commander = {
      command = getExe cfg.package;
    };
  };
}
