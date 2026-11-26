{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.ai.mcp.grep-app;
in {
  options.modules.ai.mcp.grep-app = {
    enable = mkEnableOption "grep-app mcp server";
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.grep-app = {
        url = "https://mcp.grep.app";
      };

      ai.agents = {
        antigravity.mcpServers.grep-app = {
          serverUrl = "https://mcp.grep.app";
        };

        codex.mcpServers.grep-app = {
          url = "https://mcp.grep.app";
        };

        claude-code.mcpServers.grep-app = {
          type = "http";
          url = "https://mcp.grep.app";
        };

        github-copilot-cli.settings.mcpServers.grep-app = {
          type = "http";
          url = "https://mcp.grep.app";
          tools = ["*"];
          args = [];
        };

        kiro.settings.mcpServers.grep-app = {
          url = "https://mcp.grep.app";
        };
      };
    };

    programs.opencode.settings.mcp.grep-app = {
      type = "remote";
      url = "https://mcp.grep.app";
    };
  };
}
