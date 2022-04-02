{ pkgs, ... }:
{
  programs.myNeovim.lang.lua = true;

  home.packages = with pkgs; [
    lua5_3
  ];
}
