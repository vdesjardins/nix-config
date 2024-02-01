{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (inputs) nixos-generators nixos-hardware;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (builtins) elem;
  inherit (lib.attrsets) filterAttrs;

  mkNixosSystem = path: attrs @ {system, ...}:
    nixosSystem {
      inherit system;

      specialArgs = {inherit lib inputs system nixos-hardware;};

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
