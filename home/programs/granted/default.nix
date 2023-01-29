{ config, pkgs, lib, ... }:
with lib;
{
  home.packages = with pkgs; [
    granted
  ];

  programs.zsh = {
    initExtra = ''
      alias assume="source ${pkgs.granted}/share/granted/assume"
    '';
  };
}
