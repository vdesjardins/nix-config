{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf;

  cfg = config.modules.skill.timewarrior;
in {
  options.modules.skill.timewarrior = {
    enable = mkEnableOption "timewarrior skill";

    package = mkPackageOption my-packages "skill-timewarrior-workflow" {};
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/timewarrior-workflow".source = "${cfg.package}/skills/timewarrior-workflow";

    programs.opencode.settings.permission.bash = {
      "timew --version" = "allow";
      "timew start*" = "allow";
      "timew stop" = "allow";
      "timew track*" = "allow";
      "timew tag*" = "allow";
      "timew untag*" = "allow";
      "timew retag*" = "allow";
      "timew fill*" = "allow";
      "timew summary*" = "allow";
      "timew day*" = "allow";
      "timew week*" = "allow";
      "timew month*" = "allow";
      "timew modify*" = "allow";
      "timew lengthen*" = "allow";
      "timew shorten*" = "allow";
      "timew delete*" = "allow";
      "timew annotate*" = "allow";
      "timew export*" = "allow";
      "timew undo" = "allow";
      "timew show" = "allow";
      "timew config*" = "allow";
      "timew tags" = "allow";
      "timew cancel" = "allow";
      "timew continue" = "allow";
      # Python-based tag management scripts
      "./scripts/tag_analyzer.py*" = "allow";
      "./scripts/tag_fuzzy_search.py*" = "allow";
      "./scripts/tag_report.py*" = "allow";
    };
  };
}
