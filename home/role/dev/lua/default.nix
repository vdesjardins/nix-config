{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    sumneko-lua-language-server
    lua5_3
    lua-format
  ];
}
