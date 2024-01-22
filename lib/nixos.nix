{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (inputs) nixos-generators;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (builtins) elem;
  inherit (lib.attrsets) filterAttrs;

  mkNixosSystem = path: attrs @ {system, ...}:
    nixosSystem {
      inherit system;

      specialArgs = {inherit lib inputs system;};

      modules = [
        {
          nixpkgs.pkgs = pkgs.${system};
        }
        (filterAttrs (n: v: !elem n ["system"]) attrs)
        (import path)
        nixos-generators.nixosModules.all-formats
      ];
    };
in {
  inherit mkNixosSystem;
}
