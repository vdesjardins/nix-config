{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.jiratui;
in {
  options.modules.shell.tools.jiratui = {
    enable = mkEnableOption "jiratui - terminal UI for Jira";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [jiratui];
  };
}
