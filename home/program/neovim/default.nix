{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    enableMake = true;
  };
}
