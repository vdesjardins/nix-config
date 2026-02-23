{
  config,
  lib,
  my-packages,
  ...
}:
with lib; let
  cfg = config.modules.ai.skills.jj;
in {
  options.modules.ai.skills.jj = {
    enable = mkEnableOption "jujutsu skill";
    package = mkPackageOption my-packages "skill-jj" {};
  };

  config = mkIf cfg.enable {
    modules.ai.agents.kiro.settings.resources = [
      "skill://${config.home.homeDirectory}/.kiro/skills/jj"
    ];

    programs.opencode = {
      settings.permission.bash = {
        "jj --version" = "allow";
        "jj describe *" = "allow";
        "jj diff *" = "allow";
        "jj status" = "allow";
        "jj show *" = "allow";
        "jj log *" = "allow";
        "jj edit *" = "allow";
        "jj new *" = "allow";
        "jj next" = "allow";
        "jj prev" = "allow";
        "jj absorb" = "allow";
        "jj squash *" = "allow";
        "jj split *" = "allow";
        "jj rebase *" = "allow";
        "jj restore *" = "allow";
        "jj abandon *" = "allow";
        "jj bookmark *" = "allow";
        "jj git fetch" = "allow";
        "jj git push *" = "allow";
        "jj git init" = "allow";
        "jj undo" = "allow";
        "jj op log" = "allow";
        "jj op revert *" = "allow";
        "jj resolve *" = "allow";
        "pre-commit run *" = "allow";
      };
    };

    home.file.".kiro/skills/jj".source = "${cfg.package}/skills/jj";
    xdg.configFile."opencode/skill/jj".source = "${cfg.package}/skills/jj";
  };
}
