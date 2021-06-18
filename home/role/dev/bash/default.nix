{ config, lib, pkgs, ... }:
{
  programs.neovim.enableBash = true;

  home.packages = with pkgs; [
    bash
    bats
  ];
}
