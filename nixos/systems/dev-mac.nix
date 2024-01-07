{
  darwin,
  inputs,
  pkgsConfig,
  ...
}: let
  username = "vince";
  hostname = "dev-mac";
  crossSystems = ["aarch64-linux"];
in
  darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    inherit inputs;
    modules = [
      ../modules/darwin/shared
      {
        homebrew.casks = [
          "Rectangle"
          "alt-tab"
          "bitwarden"
          "brave-browser"
          "docker"
          "firefox"
          "flameshot"
          "google-chrome"
          "google-drive"
          "hammerspoon"
          "maccy"
          "middleclick"
          "stats"
          "vmware-fusion"
        ];
      }
      (import ../modules/darwin/services/spotifyd {device_name = hostname;})
      {
        networking.hostName = hostname;

        imports = [
          (../modules/darwin/users + "/${username}.nix")
        ];
      }
      {users.knownUsers = [username];}
      {nixpkgs = pkgsConfig;}
    ];
  }
