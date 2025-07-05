{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.serena;
in {
  options.modules.mcp.serena = {
    enable = mkEnableOption "serena mcp server";

    package = mkPackageOption pkgs "serena" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.serena = {
      command = getExe cfg.package;
      args = [
        "--context"
        "ide-assistant"
        "--enable-web-dashboard=false"
      ];
      env = {
        XDG_CONFIG_HOME = "${config.xdg.configHome}";
      };
      disabled_tools = ["read_file"];
    };
  };
}
