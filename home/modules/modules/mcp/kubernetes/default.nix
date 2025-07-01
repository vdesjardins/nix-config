{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.kubernetes;
in {
  options.modules.mcp.kubernetes = {
    enable = mkEnableOption "kubernetes mcp server";

    package = mkPackageOption pkgs "mcp-server-kubernetes" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.kubernetes = {
      command = getExe cfg.package;
    };
  };
}
