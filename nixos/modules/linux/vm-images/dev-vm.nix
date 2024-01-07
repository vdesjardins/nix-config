{
  pkgs,
  pkgsConfig,
  nixos-generators,
  ...
}: let
  system = "aarch64-linux";
  newPkgsConfig = pkgsConfig // {inherit system;};
in
  nixos-generators.nixosGenerate {
    pkgs = import pkgs newPkgsConfig;
    modules = import ../configurations/dev-vm.nix {inherit pkgsConfig;};
    format = "vmware";
    specialArgs = {
      currentSystem = system;
    };
  }
