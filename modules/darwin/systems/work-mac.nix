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
          "raycast"
          "google-chrome"
          "firefox"
          "Rectangle"
          "middleclick"
          "flameshot"
          "hammerspoon"
          "google-drive"
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
