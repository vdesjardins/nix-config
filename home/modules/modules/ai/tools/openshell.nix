{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.openshell;
in {
  options.modules.ai.tools.openshell = {
    enable = mkEnableOption "OpenShell - safe, private runtime for autonomous AI agents";

    package = mkOption {
      type = types.package;
      default = my-packages.openshell;
      description = "The OpenShell package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
