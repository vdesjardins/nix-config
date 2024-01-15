{
  pkgs,
  nixos-generators,
  ...
}: let
  system = "aarch64-linux";
in
  nixos-generators.nixosGenerate {
    pkgs = pkgs.${system};
    modules = import ../configurations/dev-vm.nix {};
    format = "vmware";
    specialArgs = {
      currentSystem = system;
    };
  }
