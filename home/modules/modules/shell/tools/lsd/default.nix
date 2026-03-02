{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.lsd;
in {
  options.modules.shell.tools.lsd = {
    enable = mkEnableOption "lsd";
  };

  config = mkIf cfg.enable {
    programs = {
      lsd.enable = true;

      zsh.shellAliases = {
        lltr = "lsd -ltr";
      };

      nushell.shellAliases = {
        lltr = "lsd -ltr";
      };
    };
  };
}
