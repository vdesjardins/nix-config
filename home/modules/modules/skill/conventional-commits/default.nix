{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.skill.conventional-commits;
in {
  options.modules.skill.conventional-commits = {
    enable = mkEnableOption "conventional-commits skill for AI assistants";
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/conventional-commits" = {
      source = builtins.path {
        path = ./.;
        name = "skill-conventional-commits";
      };
      recursive = true;
    };
  };
}
