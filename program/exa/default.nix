{ config, lib, pkgs, ... }:

with lib;

{
  home.packages = with pkgs; [ exa ];

  programs.zsh.shellAliases = {
    ls = "exa";
    l = "exa";
    ll = "exa -l -s modified";
    la = "exa -la -s modified";
    lt = "exa -T";
  };
}
