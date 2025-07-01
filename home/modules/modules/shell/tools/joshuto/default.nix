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
    programs.zsh.shellAliases = {
      jo = "joshuto";
    };
  };
}
