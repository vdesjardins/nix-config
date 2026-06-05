{
  config,
  inputs,
  lib,
  my-packages,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.parallel;

  skills = [
    "parallel-web-search"
    "parallel-web-extract"
    "parallel-deep-research"
    "parallel-data-enrichment"
    "parallel-findall"
    "parallel-monitor"
    "parallel-cli-setup"
    "status"
    "result"
  ];

  mkSkillFiles = baseDir:
    builtins.listToAttrs (
      map (
        skill: {
          name = "${baseDir}/${skill}";
          value.source = "${cfg.skills.package}/skills/${skill}";
        }
      )
      skills
    );
in {
  options.modules.ai.tools.parallel = {
    enable = mkEnableOption "Parallel CLI and agent skills";

    package = mkOption {
      type = types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.parallel-cli;
      description = "The parallel-cli package to use";
    };

    skills = {
      enable = mkEnableOption "Parallel Agent Skills (web search, extract, deep research, enrichment)";

      package = mkOption {
        type = types.package;
        default = my-packages.parallel-agent-skills;
        description = "The Parallel Agent Skills package to use";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package] ++ lib.optionals cfg.skills.enable [cfg.skills.package];

    home.file = lib.mkIf cfg.skills.enable (
      mkSkillFiles ".pi/agent/skills"
      // mkSkillFiles ".kiro/skills"
      // mkSkillFiles ".copilot/skills"
      // mkSkillFiles ".claude/skills"
    );

    xdg.configFile = lib.mkIf cfg.skills.enable (mkSkillFiles "opencode/skill");
  };
}
