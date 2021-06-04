{ config, lib, pkgs, ... }:
let lua-format = pkgs.callPackage ../../../program/lua-format { };
in {
  home.packages = with pkgs; [ sumneko-lua-language-server lua5_3 lua-format ];
}
