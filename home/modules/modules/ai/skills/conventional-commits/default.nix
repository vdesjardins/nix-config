{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.skills.conventional-commits;
in {
  options.modules.ai.skills.conventional-commits = {
    enable = mkEnableOption "conventional-commits skill for AI assistants";
  };

  config = mkIf cfg.enable {
    modules.ai.agents.kiro.settings.resources = [
      "skill://${config.home.homeDirectory}/.kiro/skills/conventional-commits"
    ];

    home.file.".kiro/skills/conventional-commits" = {
      source = builtins.path {
        path = ./.;
        name = "skill-conventional-commits";
      };
      recursive = true;
    };

    xdg.configFile."opencode/skill/conventional-commits" = {
      source = builtins.path {
        path = ./.;
        name = "skill-conventional-commits";
      };
      recursive = true;
    };
  };
}
