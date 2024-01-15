{lib, ...}: let
  inherit (lib.my) mkHomeConfiguration;
in {
  "dev-vm/vince" = mkHomeConfiguration ../users/vince-vm.nix {system = "aarch64-linux";};
  "dev-mac/vince" = mkHomeConfiguration ../users/vince-mac.nix {system = "aarch64-darwin";};
  "V07P6L7R6H/inf10906" = mkHomeConfiguration ../users/inf10906.nix {system = "aarch64-darwin";};
}
