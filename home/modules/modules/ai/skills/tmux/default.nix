{
  config,
  lib,
  my-packages,
  ...
}:
with lib; let
  cfg = config.modules.ai.skills.tmux;
in {
  options.modules.ai.skills.tmux = {
    enable = mkEnableOption "tmux skill";
    package = mkPackageOption my-packages "skill-tmux" {};
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/tmux".source = "${cfg.package}/skills/tmux";
  };
}
