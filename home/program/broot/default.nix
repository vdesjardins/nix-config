{ lib, ... }:

with lib;

{
  programs.broot = { enable = true; };

  programs.zsh.initExtra = ''
    source $profile/share/bash-completion/completions/broot.bash
  '';
}
