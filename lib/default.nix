{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.fixedPoints) makeExtensible;
  inherit (lib.lists) foldr;
  inherit (modules) mapModulesRecursive;

  modules = import ./modules.nix {
    inherit lib;
  };

  mylib = makeExtensible (self: mapModulesRecursive ./. (file: import file {inherit self lib pkgs inputs;}));
in
  mylib.extend (self: super: foldr (a: b: a // b) {} (attrValues super))
