{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf concatStringsSep;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) attrsOf attrs listOf str lines;

  cfg = config.modules.ai.agents.github-copilot-cli;

  # Concatenate all prompts with double newline separator for custom instructions
  combinedInstructions = concatStringsSep "\n\n" cfg.settings.prompts;

  hasMcpServers = cfg.settings.mcpServers != {};
  hasInstructions = cfg.settings.prompts != [];
  hasResources = cfg.settings.resources != [];

  # MCP configuration for ~/.copilot/mcp-config.json
  mcpConfig = {
    inherit (cfg.settings) mcpServers;
  };
in {
  options.modules.ai.agents.github-copilot-cli = {
    enable = mkEnableOption "github-copilot-cli";

    settings = {
      mcpServers = mkOption {
        type = attrsOf attrs;
        description = "MCP servers configuration for ~/.copilot/mcp-config.json";
        default = {};
      };

      resources = mkOption {
        type = listOf str;
        description = "Resources (skills, files) paths for the agent";
        default = [];
      };

      prompts = mkOption {
        type = listOf lines;
        description = "Custom instructions for ~/.copilot/copilot-instructions.md";
        default = [];
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli
      pkgs.bashInteractive
    ];

    xdg.configFile = {
      ".copilot/mcp-config.json" = mkIf hasMcpServers {
        text = builtins.toJSON mcpConfig;
      };

      ".copilot/copilot-instructions.md" = mkIf hasInstructions {
        text = combinedInstructions;
      };
    };
  };
}
