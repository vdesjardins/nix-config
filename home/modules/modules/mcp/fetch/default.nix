{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.fetch;
in {
  options.modules.mcp.fetch = {
    enable = mkEnableOption "fetch mcp server";

    package = mkPackageOption pkgs "mcp-server-fetch" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.fetch = {
      command = getExe cfg.package;
    };
  };
}
