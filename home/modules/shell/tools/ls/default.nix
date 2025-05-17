{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.ls;
in {
  options.modules.shell.tools.ls = {
    enable = mkEnableOption "ls";
  };

  config = mkIf cfg.enable {
    home.file.".dircolors".source = "${pkgs.lscolors}/share/lscolors/LS_COLORS";

    programs.zsh.initContent = ''
      eval $(${pkgs.coreutils}/bin/dircolors -b ~/.dircolors)
    '';
  };
}
