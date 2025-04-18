{lib, ...}: let
  inherit (lib.my) mkNixosSystem;
in {
  dev-vm = mkNixosSystem ../modules/linux/configurations/dev-vm.nix {system = "aarch64-linux";};
  falcon = mkNixosSystem ../modules/linux/configurations/falcon.nix {system = "x86_64-linux";};
  v = mkNixosSystem ../modules/linux/configurations/v.nix {system = "x86_64-linux";};
  home-server = mkNixosSystem ../modules/linux/configurations/home-server.nix {system = "aarch64-linux";};
}
