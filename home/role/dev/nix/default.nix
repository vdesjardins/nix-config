{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    rnix-lsp
    nixfmt
  ];
}
