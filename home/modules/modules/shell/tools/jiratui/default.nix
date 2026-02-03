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

    # Add zsh alias with tokyo-night theme
    programs.zsh.shellAliases.jtui = "jiratui ui --theme tokyo-night";

    # Add nushell alias with tokyo-night theme
    programs.nushell.shellAliases.jtui = "jiratui ui --theme tokyo-night";
  };
}
