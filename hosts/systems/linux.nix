{lib, ...}: let
  inherit (lib.my) mkNixosSystem;
in {
  "dev-vm" = mkNixosSystem ../modules/linux/configurations/dev-vm.nix {system = "aarch64-linux";};
}
