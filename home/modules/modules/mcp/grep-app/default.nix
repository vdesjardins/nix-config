{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.mcp.grep-app;
in {
  options.modules.mcp.grep-app = {
    enable = mkEnableOption "grep-app mcp server";
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.grep-app = {
        url = "https://mcp.grep.app";
      };

      mcp.utcp-code-mode.mcpServers.grep-app = {
        transport = "http";
        url = "https://mcp.grep.app";
      };

      shell.tools.github-copilot-cli.settings.mcpServers.grep-app = {
        type = "http";
        url = "https://mcp.grep.app";
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.grep-app = {
      type = "remote";
      url = "https://mcp.grep.app";
    };

    programs.codex.settings.mcp_servers.grep-app = {
      enabled = false;
      url = "https://mcp.grep.app";
    };
  };
}
