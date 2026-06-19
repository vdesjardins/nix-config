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

  cfg = config.modules.ai.tools.officecli;

  skills = [
    "officecli"
    "officecli-docx"
    "officecli-xlsx"
    "officecli-pptx"
    "officecli-word-form"
    "officecli-pitch-deck"
    "officecli-data-dashboard"
    "officecli-financial-model"
    "officecli-academic-paper"
    "morph-ppt"
    "morph-ppt-3d"
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
  options.modules.ai.tools.officecli = {
    enable = mkEnableOption "officecli";

    package = mkOption {
      type = types.package;
      default = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.officecli;
      description = "The officecli package to use";
    };

    skills = {
      enable = mkEnableOption "OfficeCLI skills";

      package = mkOption {
        type = types.package;
        default = my-packages.officecli-skills;
        description = "The OfficeCLI skills package to use";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package] ++ lib.optionals cfg.skills.enable [cfg.skills.package];

    home.file = mkIf cfg.skills.enable (
      (mkSkillFiles ".kiro/skills")
      // (mkSkillFiles ".copilot/skills")
      // (mkSkillFiles ".pi/agent/skills")
    );

    xdg.configFile = mkIf cfg.skills.enable (mkSkillFiles "opencode/skill");
  };
}
