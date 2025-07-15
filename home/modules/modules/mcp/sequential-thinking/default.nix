{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.sequential-thinking;
in {
  options.modules.mcp.sequential-thinking = {
    enable = mkEnableOption "sequential-thinking mcp server";

    package = mkPackageOption pkgs "mcp-server-sequential-thinking" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.sequential-thinking = {
      command = getExe cfg.package;
    };
  };
}
