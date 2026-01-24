{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  cfg = config.modules.ai.skills.writing-skills;
in {
  options.modules.ai.skills.writing-skills = {
    enable = mkEnableOption "writing-skills";
    package = mkOption {
      type = lib.types.package;
      default = my-packages.writing-skills;
      description = "writing-skills package";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/writing-skills".source = "${cfg.package}/skills/writing-skills";
  };
}
