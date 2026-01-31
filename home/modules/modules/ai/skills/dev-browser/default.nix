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
    enable = mkEnableOption "dev-browser skill (now uses agent-browser)";

    package = mkPackageOption my-packages "agent-browser" {};
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    # Recursively link all skill files and documentation
    # Dev-browser now uses agent-browser for backward compatibility
    xdg.configFile."opencode/skill/dev-browser" = {
      source = "${cfg.package}/skills/agent-browser";
      recursive = true;
    };
  };
}
