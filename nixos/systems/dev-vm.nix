{
  nixpkgs,
  pkgsConfig,
  ...
}: let
  system = "aarch64-linux";
in
  nixpkgs.lib.nixosSystem {
    inherit system;

    modules =
      import ../modules/linux/configurations/dev-vm.nix {inherit pkgsConfig;}
      ++ [
        {
          _module.args = {
            currentSystem = system;
            naturalMouseScrolling = false;
          };
        }
      ];
  }
