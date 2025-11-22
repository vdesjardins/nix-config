{
  inputs,
  my-packages,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (builtins) elem;
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  inherit (inputs.nix-index-database.homeModules) nix-index;
  inherit (inputs.nixvim.homeModules) nixvim;
  inherit (lib.attrsets) filterAttrs;
  inherit (self.modules) mapModulesRecursive';
  try = inputs.try.homeModules.default;

  mkHomeConfiguration = path: attrs @ {system, ...}:
    homeManagerConfiguration {
      pkgs = pkgs.${system};
      inherit lib;

      extraSpecialArgs = {
        inherit inputs;
        my-packages = my-packages.${system};
      };

      modules =
        [
          (filterAttrs (n: v: !elem n ["system"]) attrs)
          (import path)
          nix-index
          nixvim
          try
        ]
        ++ mapModulesRecursive' ../home/modules import;
    };
in {
  inherit mkHomeConfiguration;
}
