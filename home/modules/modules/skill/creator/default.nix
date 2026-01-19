{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  cfg = config.modules.skill.creator;
in {
  options.modules.skill.creator = {
    enable = mkEnableOption "skill-creator";
    package = mkOption {
      type = lib.types.package;
      default = my-packages.skill-creator;
      description = "skill-creator package";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/creator".source = "${cfg.package}/skills/creator";
  };
}
