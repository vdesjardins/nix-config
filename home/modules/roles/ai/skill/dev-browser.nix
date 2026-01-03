{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.skill.dev-browser;
in {
  options.roles.ai.skill.dev-browser = {
    enable = mkEnableOption "dev-browser skill";
  };

  config = mkIf cfg.enable {
    modules.skill.dev-browser.enable = true;
  };
}
