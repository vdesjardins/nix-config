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
    xdg.configFile."opencode/skill/conventional-commits" = {
      source = builtins.path {
        path = ./.;
        name = "skill-conventional-commits";
      };
      recursive = true;
    };
  };
}
