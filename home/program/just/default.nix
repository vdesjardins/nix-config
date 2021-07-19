{ pkgs, ... }: {
  home.packages = with pkgs; [ just ];

  programs.zsh.initExtra = ''
    source $profile/share/bash-completion/completions/just.bash
  '';
}
