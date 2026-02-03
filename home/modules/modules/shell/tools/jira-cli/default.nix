{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.jira-cli;
in {
  options.modules.shell.tools.jira-cli = {
    enable = mkEnableOption "jira-cli - command-line tool for Jira";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [jira-cli-go];
  };
}
