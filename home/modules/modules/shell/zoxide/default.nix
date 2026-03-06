{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.zoxide;
in {
  options.modules.shell.zoxide = {
    enable = mkEnableOption "zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = config.modules.shell.zsh.enable;
      enableNushellIntegration = config.modules.shell.nushell.enable;
    };
  };
}
