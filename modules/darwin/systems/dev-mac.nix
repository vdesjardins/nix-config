{
  darwin,
  inputs,
  pkgsConfig,
}: let
  username = "vince";
  hostname = "dev-mac";
  crossSystems = ["aarch64-linux"];
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
          "brave-browser"
          "bitwarden"
          "Rectangle"
          "docker"
          "vmware-fusion"
          "middleclick"
          "flameshot"
          "hammerspoon"
          "google-drive"
          "stats"
        ];
      }
      (import ../services/spotifyd {device_name = hostname;})
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
