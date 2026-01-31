{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.ai.tools.beads_viewer;
in {
  options.modules.ai.tools.beads_viewer = {
    enable = mkEnableOption "beads_viewer - TUI viewer for beads issue tracking system";

    package = mkOption {
      type = types.package;
      default = my-packages.beads_viewer;
      description = "The beads_viewer package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
