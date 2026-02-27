{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.ai.skills.coding-agent-search;

  # Reference to the coding-agent-search package and its source
  cassPackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.coding-agent-search;
  cassSource = cassPackage.src;
in {
  options.modules.ai.skills.coding-agent-search = {
    enable = mkEnableOption "coding-agent-search skill";
  };

  config = mkIf cfg.enable {
    # Register with AI agents
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/coding-agent-search"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/coding-agent-search"
      ];
    };

    # Install the package
    home.packages = [cassPackage];

    # Link SKILL.md to all agent skill directories
    home.file = {
      ".kiro/skills/coding-agent-search/SKILL.md" = {
        source = "${cassSource}/SKILL.md";
      };

      ".copilot/skills/coding-agent-search/SKILL.md" = {
        source = "${cassSource}/SKILL.md";
      };
    };

    xdg.configFile = {
      "opencode/skill/coding-agent-search/SKILL.md" = {
        source = "${cassSource}/SKILL.md";
      };
    };
  };
}
