{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.context7;
in {
  options.modules.mcp.context7 = {
    enable = mkEnableOption "context7 mcp server";

    package = mkPackageOption pkgs "context7" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.context7 = {
      command = getExe cfg.package;
    };
  };
}
