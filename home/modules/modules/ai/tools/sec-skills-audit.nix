{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.sec-skills-audit;
in {
  options.modules.ai.tools.sec-skills-audit = {
    enable = mkEnableOption "sec-skills-audit - security auditor for OpenCode skill files";

    package = mkOption {
      type = types.package;
      default = my-packages.sec-skills-audit;
      description = "The sec-skills-audit package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
