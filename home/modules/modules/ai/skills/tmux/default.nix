{
  config,
  lib,
  my-packages,
  ...
}:
with lib; let
  cfg = config.modules.ai.skills.tmux;
in {
  options.modules.ai.skills.tmux = {
    enable = mkEnableOption "tmux skill";
    package = mkPackageOption my-packages "skill-tmux" {};
  };

  config = mkIf cfg.enable {
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/tmux"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/tmux"
      ];
    };

    home.file = {
      ".kiro/skills/tmux".source = "${cfg.package}/skills/tmux";
      ".copilot/skills/tmux".source = "${cfg.package}/skills/tmux";
      ".pi/agent/skills/tmux".source = "${cfg.package}/skills/tmux";
      ".gemini/antigravity-cli/skills/tmux" = lib.mkIf config.modules.ai.agents.antigravity.enable {
        source = "${cfg.package}/skills/tmux/skills/tmux";
      };
      ".agents/skills/tmux" = lib.mkIf config.modules.ai.agents.codex.enable {
        source = "${cfg.package}/skills/tmux/skills/tmux";
      };
      ".claude/skills/tmux" = lib.mkIf config.modules.ai.agents.claude-code.enable {
        source = "${cfg.package}/skills/tmux/skills/tmux";
      };
    };

    xdg.configFile = {
      "opencode/skill/tmux".source = "${cfg.package}/skills/tmux";
      ".copilot/skills/tmux".source = "${cfg.package}/skills/tmux";
    };
  };
}
