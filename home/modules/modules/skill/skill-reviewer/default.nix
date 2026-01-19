{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  cfg = config.modules.skill.skill-reviewer;
in {
  options.modules.skill.skill-reviewer = {
    enable = mkEnableOption "skill-reviewer";
    package = mkOption {
      type = lib.types.package;
      default = my-packages.skill-reviewer;
      description = "skill-reviewer package";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/skill-reviewer".source = "${cfg.package}/skills/skill-reviewer";
  };
}
