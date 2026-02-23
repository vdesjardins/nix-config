{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf concatStringsSep;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrsOf attrs listOf str lines;

  cfg = config.modules.ai.agents.kiro;

  # Concatenate all prompts with double newline separator
  combinedPrompt = concatStringsSep "\n\n" cfg.settings.prompts;

  hasMcpServers = cfg.settings.mcpServers != {};
  hasAgentConfig = cfg.settings.resources != [] || cfg.settings.prompts != [];

  # MCP configuration for ~/.kiro/settings/mcp.json
  mcpConfig = {
    inherit (cfg.settings) mcpServers;
  };

  # Agent configuration for ~/.config/kiro/agents/default.json
  agentConfig =
    {
      name = "default";
      description = "Default Kiro agent with MCP servers, skills, and prompts";
      tools = ["*"];
      allowedTools = ["read"];
      includeMcpJson = true;
    }
    // (lib.optionalAttrs (cfg.settings.resources != []) {
      inherit (cfg.settings) resources;
    })
    // (lib.optionalAttrs (cfg.settings.prompts != []) {
      prompt = combinedPrompt;
    });
in {
  options.modules.ai.agents.kiro = {
    enable = mkEnableOption "kiro-cli";

    settings = {
      mcpServers = mkOption {
        type = attrsOf attrs;
        description = "MCP servers configuration";
        default = {};
      };

      resources = mkOption {
        type = listOf str;
        description = "Resources (skills, files) for the agent";
        default = [];
      };

      prompts = mkOption {
        type = listOf lines;
        description = "Agent prompts/instructions (will be concatenated)";
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.kiro-cli
    ];

    home.file = {
      ".kiro/settings/mcp.json" = mkIf hasMcpServers {
        text = builtins.toJSON mcpConfig;
      };

      ".kiro/agents/default.json" = mkIf hasAgentConfig {
        text = builtins.toJSON agentConfig;
      };
    };
  };
}
