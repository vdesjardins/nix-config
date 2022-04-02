{ pkgs, ... }:
{
  programs.myNeovim.lang.json = true;

  home.packages = with pkgs; [
    nodePackages.fixjson
    jiq
    jq
    gron
  ];
}
