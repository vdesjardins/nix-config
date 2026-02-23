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
    modules.ai.agents.kiro.settings.resources = [
      "skill://${config.home.homeDirectory}/.kiro/skills/skill-reviewer"
    ];

    home.file.".kiro/skills/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
    xdg.configFile."opencode/skill/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
  };
}
