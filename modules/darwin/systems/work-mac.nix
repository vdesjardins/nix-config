{
  darwin,
  inputs,
  pkgsConfig,
}: let
  username = "inf10906";
  hostname = "V07P6L7R6H";
in
  darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    inherit inputs;
    modules = [
      ../shared
      {
        homebrew.casks = [
          "Rectangle"
          "firefox"
          "flameshot"
          "google-chrome"
          "google-drive"
          "hammerspoon"
          "maccy"
          "middleclick"
          "raycast"
          "stats"
        ];
      }
      {
        networking.hostName = hostname;

        imports = [
          (../users + "/${username}.nix")
        ];
      }
      {users.knownUsers = [username];}
      {nixpkgs = pkgsConfig;}
    ];
  }
