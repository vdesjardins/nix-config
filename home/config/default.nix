{lib, ...}: let
  inherit (lib.my) mkHomeConfiguration;
in {
  "vince@dev-vm" = mkHomeConfiguration ../users/vince-vm.nix {system = "aarch64-linux";};
  "vince@falcon" = mkHomeConfiguration ../users/vince-falcon.nix {system = "x86_64-linux";};
  "vince@v" = mkHomeConfiguration ../users/vince-v.nix {system = "x86_64-linux";};
  "vince@dev-mac" = mkHomeConfiguration ../users/vince-mac.nix {system = "aarch64-darwin";};
  "inf10906@V07P6L7R6H" = mkHomeConfiguration ../users/inf10906.nix {system = "aarch64-darwin";};
}
