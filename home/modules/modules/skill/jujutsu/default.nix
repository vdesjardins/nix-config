{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.skill.jujutsu;
in {
  options.modules.skill.jujutsu = {
    enable = mkEnableOption "jujutsu skill";
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/jujutsu-workflow/SKILL.md".source = ./SKILL.md;

    programs.opencode.settings.permission.bash = {
      "jj describe" = "allow";
      "jj diff" = "allow";
      "jj status" = "allow";
      "jj show" = "allow";
      "jj log" = "allow";
      "jj edit" = "allow";
      "jj new" = "allow";
      "jj next" = "allow";
      "jj prev" = "allow";
      "jj absorb" = "allow";
      "jj squash" = "allow";
      "jj split" = "allow";
      "jj rebase" = "allow";
      "jj restore" = "allow";
      "jj abandon" = "allow";
      "jj bookmark" = "allow";
      "jj git fetch" = "allow";
      "jj git push" = "allow";
      "jj init" = "allow";
      "jj undo" = "allow";
      "jj op log" = "allow";
      "jj resolve" = "allow";
      "pre-commit run" = "allow";
    };
  };
}
