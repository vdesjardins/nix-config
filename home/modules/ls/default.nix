{
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.ls;
in {
  options.programs.ls = {
    enable = mkEnableOption "ls";
  };

  config = {
    home.file.".dircolors".source = "${pkgs.lscolors}/share/lscolors/LS_COLORS";

    programs.zsh.initExtra = ''
      eval $(${pkgs.coreutils}/bin/dircolors -b ~/.dircolors)
    '';
  };
}
