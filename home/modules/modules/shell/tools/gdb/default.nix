{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.gdb;
in {
  options.modules.shell.tools.gdb = {
    enable = mkEnableOption "gdb";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [gdb];

    xdg.configFile."gdb/gdbinit".source =
      ./gdbinit;
  };
}
