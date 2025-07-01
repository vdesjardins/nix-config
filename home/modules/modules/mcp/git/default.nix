{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.git;
in {
  options.modules.mcp.git = {
    enable = mkEnableOption "git mcp server";

    package = mkPackageOption pkgs "mcp-server-git" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.git = {
      command = getExe cfg.package;
    };
  };
}
