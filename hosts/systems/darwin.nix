{lib, ...}: let
  inherit (lib.my) mkDarwinSystem;
in {
  "dev-mac" = mkDarwinSystem ../modules/darwin/configurations/dev-mac.nix {system = "aarch64-darwin";};
  "FCV4TW0H2P" = mkDarwinSystem ../modules/darwin/configurations/FCV4TW0H2P.nix {system = "aarch64-darwin";};
}
