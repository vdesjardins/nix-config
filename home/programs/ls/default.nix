{
  config,
  pkgs,
  ...
}: {
  home.file.".dircolors".source = "${pkgs.lscolors}/share/lscolors/LS_COLORS";

  programs.zsh.initExtra = ''
    eval $(${pkgs.coreutils}/bin/dircolors -b ~/.dircolors)
  '';
}
