{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  cfg = config.modules.ai.skills.skill-reviewer;
in {
  options.modules.ai.skills.skill-reviewer = {
    enable = mkEnableOption "skill-reviewer";
    package = mkOption {
      type = lib.types.package;
      default = my-packages.skill-reviewer;
      description = "skill-reviewer package";
    };
  };

  config = mkIf cfg.enable {
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/skill-reviewer"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/skill-reviewer"
      ];
    };

    home.file = {
      ".kiro/skills/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
      ".copilot/skills/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
      ".pi/agent/skills/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
      ".gemini/antigravity-cli/skills/skill-reviewer" = lib.mkIf config.modules.ai.agents.antigravity.enable {
        source = "${cfg.package}/skills/skill-reviewer/skills/skill-reviewer";
      };
      ".agents/skills/skill-reviewer" = lib.mkIf config.modules.ai.agents.codex.enable {
        source = "${cfg.package}/skills/skill-reviewer/skills/skill-reviewer";
      };
      ".claude/skills/skill-reviewer" = lib.mkIf config.modules.ai.agents.claude-code.enable {
        source = "${cfg.package}/skills/skill-reviewer/skills/skill-reviewer";
      };
    };

    xdg.configFile = {
      "opencode/skill/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
      ".copilot/skills/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
    };
  };
}
