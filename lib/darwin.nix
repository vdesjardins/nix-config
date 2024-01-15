{
  inputs,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (inputs.nix-darwin.lib) darwinSystem;
  inherit (builtins) elem;
  inherit (lib.attrsets) filterAttrs;

  mkDarwinSystem = path: attrs @ {system, ...}:
    darwinSystem {
      inherit system;

      specialArgs = {inherit lib inputs system;};

      modules = [
        {
          nixpkgs.pkgs = pkgs.${system};
        }
        (filterAttrs (n: v: !elem n ["system"]) attrs)
        (import path)
      ];
    };
in {
  inherit mkDarwinSystem;
}
