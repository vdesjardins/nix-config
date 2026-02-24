{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  cfg = config.modules.ai.skills.skill-creator;
in {
  options.modules.ai.skills.skill-creator = {
    enable = mkEnableOption "skill-creator";
    package = mkOption {
      type = lib.types.package;
      default = my-packages.skill-creator;
      description = "skill-creator package";
    };
  };

  config = mkIf cfg.enable {
    modules.ai.agents = {
      kiro.settings.resources = [
        "skill://${config.home.homeDirectory}/.kiro/skills/skill-creator"
      ];

      github-copilot-cli.settings.resources = [
        "skill://${config.home.homeDirectory}/.copilot/skills/skill-creator"
      ];
    };

    home.file = {
      ".kiro/skills/skill-creator".source = "${cfg.package}/skills/skill-creator";
      ".copilot/skills/skill-creator".source = "${cfg.package}/skills/skill-creator";
    };

    xdg.configFile = {
      "opencode/skill/skill-creator".source = "${cfg.package}/skills/skill-creator";
      ".copilot/skills/skill-creator".source = "${cfg.package}/skills/skill-creator";
    };
  };
}
