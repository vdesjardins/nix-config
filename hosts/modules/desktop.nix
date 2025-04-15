# This file contains configuration that is shared across all hosts.
{pkgs, ...}: let
  fonts = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.monaspace
    nerd-fonts.fira-code
    fira-code
    maple-mono.NF
    maple-mono.variable
    noto-fonts
    noto-fonts-emoji
  ];
in {
  fonts.packages = fonts;
}
