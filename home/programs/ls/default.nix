{ config, pkgs, ... }: {
  home.file.".dircolors".source = "${pkgs.lscolors}/share/lscolors/LS_COLORS";

  programs.zsh.initExtra = ''
      source <(dircolors ${
    config.home.homeDirectory + "/" + config.home.file.".dircolors".target
    })
  '';
}
