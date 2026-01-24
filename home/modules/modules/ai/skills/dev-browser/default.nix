{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf;

  cfg = config.modules.ai.skills.dev-browser;
in {
  options.modules.ai.skills.dev-browser = {
    enable = mkEnableOption "dev-browser skill";

    package = mkPackageOption my-packages "skill-dev-browser" {};
  };

  config = mkIf cfg.enable {
    xdg.configFile."opencode/skill/dev-browser".source = "${cfg.package}/skills/dev-browser";
  };
}
