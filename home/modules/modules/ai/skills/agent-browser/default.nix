{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf;

  cfg = config.modules.ai.skills.agent-browser;
in {
  options.modules.ai.skills.agent-browser = {
    enable = mkEnableOption "agent-browser skill";

    package = mkPackageOption my-packages "agent-browser" {};
  };

  config = mkIf cfg.enable {
    # Recursively link all skill files and documentation
    xdg.configFile."opencode/skill/agent-browser" = {
      source = "${cfg.package}/skills/agent-browser";
      recursive = true;
    };
  };
}
