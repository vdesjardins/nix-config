{
  pkgs,
  pkgsConfig,
}: let
  system = "aarch64-linux";
in
  pkgs.lib.nixosSystem {
    inherit system;

    modules =
      import ../configurations/dev-vm.nix {inherit pkgsConfig;}
      ++ [
        {
          _module.args = {
            currentSystem = system;
            naturalMouseScrolling = false;
          };
        }
      ];
  }
