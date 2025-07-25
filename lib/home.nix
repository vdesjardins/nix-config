{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (builtins) elem;
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  inherit (inputs.nix-index-database.homeModules) nix-index;
  inherit (inputs.nixvim.homeManagerModules) nixvim;
  inherit (lib.attrsets) filterAttrs;
  inherit (self.modules) mapModulesRecursive';

  mkHomeConfiguration = path: attrs @ {system, ...}:
    homeManagerConfiguration {
      pkgs = pkgs.${system};
      inherit lib;

      modules =
        [
          (filterAttrs (n: v: !elem n ["system"]) attrs)
          (import path)
          nix-index
          nixvim
        ]
        ++ mapModulesRecursive' ../home/modules import;
    };
in {
  inherit mkHomeConfiguration;
}
