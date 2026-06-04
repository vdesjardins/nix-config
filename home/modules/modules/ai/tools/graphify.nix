{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.graphify;

  # skill.md is installed by setuptools into the package's site-packages
  skillMd = "${my-packages.graphify}/lib/python3.12/site-packages/graphify/skill.md";
in {
  options.modules.ai.tools.graphify = {
    enable = mkEnableOption "graphify - Claude Code skill to turn code/docs into queryable knowledge graph";
  };

  config = mkIf cfg.enable {
    home = {
      # Install the graphify CLI (buildPythonPackage wraps entry points under bin/)
      packages = [my-packages.graphify];

      # Place skill.md for each agent that reads from a skills directory
      file = {
        ".pi/agent/skills/graphify/SKILL.md".source = skillMd;
        ".kiro/skills/graphify/SKILL.md".source = skillMd;
        ".copilot/skills/graphify/SKILL.md".source = skillMd;
        ".claude/skills/graphify/SKILL.md".source = skillMd;
      };
    };

    # OpenCode reads skills from ~/.config/opencode/skill/
    xdg.configFile."opencode/skill/graphify/SKILL.md".source = skillMd;
  };
}
