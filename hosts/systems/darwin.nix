{lib, ...}: let
  inherit (lib.my) mkDarwinSystem;
in {
  "dev-mac" = mkDarwinSystem ../modules/darwin/configurations/dev-mac.nix;
  "V07P6L7R6H" = mkDarwinSystem ../modules/darwin/configurations/V07P6L7R6H.nix;
}
