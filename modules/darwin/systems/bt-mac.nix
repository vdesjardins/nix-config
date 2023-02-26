{
  darwin,
  inputs,
  pkgsConfig,
}: let
  username = "vincentdesjardins";
  hostname = "vincentdesjardins";
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
          "docker"
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
