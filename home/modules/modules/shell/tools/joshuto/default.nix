{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.joshuto;
in {
  options.modules.shell.tools.joshuto = {
    enable = mkEnableOption "joshuto filebrowser";
  };

  config = mkIf cfg.enable {
    programs = {
      bash.shellAliases = {
        jo = "joshuto";
      };
      zsh.shellAliases = {
        jo = "joshuto";
      };
    };

    modules.shell.nushell.globalAliases = {
      jo = "joshuto";
    };
  };
}
