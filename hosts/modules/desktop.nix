# This file contains configuration that is shared across all hosts.
{
  pkgs,
  lib,
  stdenv,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (pkgs) stdenv;
  inherit (stdenv) isDarwin isLinux;

  fonts = with pkgs; [
    (unstable.nerdfonts.override {fonts = ["JetBrainsMono" "Monaspace"];})
    noto-fonts
    noto-fonts-emoji
  ];
in {
  fonts.packages = fonts;
}
