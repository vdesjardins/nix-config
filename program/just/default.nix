{ config, pkgs, ... }: {
  home.packages = with pkgs; [ just ];

  programs.zsh.initExtra = ''
    source <(${pkgs.just}/bin/just --completions zsh) 2>/dev/null
  '';
}
