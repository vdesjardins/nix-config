{ pkgs, pkgsConfig }:
let
  system = "aarch64-linux";
in
pkgs.lib.nixosSystem {
  inherit system;

  modules = import ../configurations/dev-vm.nix { inherit pkgsConfig; };

  extraArgs = {
    currentSystem = system;
  };
}
