{
  config,
  pkgs,
  lib,
  stdenv,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.zellij;
in {
  options.modules.shell.tools.zellij = {
    enable = mkEnableOption "yazi filebrowser";
  };

  config = mkIf cfg.enable {
    xdg.configFile."zellij/config.kdl".source = ./config.kdl;
    xdg.configFile."zellij/layouts".source = ./layouts;
  };
}
