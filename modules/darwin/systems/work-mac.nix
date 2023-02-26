{
  darwin,
  inputs,
  pkgsConfig,
}: let
  username = "inf10906";
  hostname = "C02ZNNXRMD6M";
in
  darwin.lib.darwinSystem {
    system = "x86_64-darwin";
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
