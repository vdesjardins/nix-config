{
  config,
  lib,
  my-packages,
  ...
}:
with lib; let
  cfg = config.modules.skill.tmux;
in {
  options.modules.skill.tmux = {
    enable = mkEnableOption "tmux skill";
    package = mkPackageOption my-packages "skill-tmux" {};
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/tmux".source = "${cfg.package}/skills/tmux";
  };
}
