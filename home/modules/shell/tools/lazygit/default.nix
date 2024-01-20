{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.lazygit;
in {
  options.modules.shell.tools.lazygit = {
    enable = mkEnableOption "lazygit";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      inherit (cfg) enable;

      settings = {
        git = {
          quitOnTopLevelReturn = true;
          disableStartupPopups = true;
        };
      };
    };

    programs.zsh.shellAliases = {
      lg = "lazygit";
    };
  };
}
