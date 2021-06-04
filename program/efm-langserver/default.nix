{ config, lib, pkgs, ... }:
let efm-langserver = pkgs.callPackage ./efm-langserver.nix { };
in { home.packages = [ efm-langserver ]; }
