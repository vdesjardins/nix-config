{
  config,
  lib,
  my-packages,
  ...
}:
with lib; let
  cfg = config.modules.skill.jj;
in {
  options.modules.skill.jj = {
    enable = mkEnableOption "jujutsu skill";
    package = mkPackageOption my-packages "skill-jj" {};
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/jj".source = "${cfg.package}/skills/jj";
  };
}
