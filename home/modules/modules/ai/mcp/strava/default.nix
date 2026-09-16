{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.ai.mcp.strava;
  url = "https://mcp.strava.com/mcp";
in {
  options.modules.ai.mcp.strava = {
    enable = mkEnableOption "Strava MCP server";
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.strava = {
        inherit url;
      };

      ai.agents = {
        github-copilot-cli.settings.mcpServers.strava = {
          type = "http";
          inherit url;
          tools = ["*"];
          args = [];
        };

        kiro.settings.mcpServers.strava = {
          inherit url;
        };
      };
    };

    programs.opencode.settings.mcp.strava = {
      type = "remote";
      inherit url;
    };
  };
}
