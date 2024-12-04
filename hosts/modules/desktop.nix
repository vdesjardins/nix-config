# This file contains configuration that is shared across all hosts.
{pkgs, ...}: let
  fonts = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    noto-fonts
    noto-fonts-emoji
  ];
in {
  fonts.packages = fonts;
}
