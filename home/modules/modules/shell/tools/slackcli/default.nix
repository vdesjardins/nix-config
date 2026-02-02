{
  config,
  lib,
  pkgs,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.slackcli;
in {
  options.modules.shell.tools.slackcli = {
    enable = mkEnableOption "slackcli - CLI application for Slack";
  };

  config = mkIf cfg.enable {
    home.packages = [
      my-packages.slackcli
    ];
  };
}
