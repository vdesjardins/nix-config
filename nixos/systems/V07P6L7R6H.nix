{
  darwin,
  inputs,
  pkgsConfig,
  ...
}: let
  username = "inf10906";
  hostname = "V07P6L7R6H";
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
          "firefox"
          "flameshot"
          "google-chrome"
          "google-drive"
          "hammerspoon"
          "maccy"
          "middleclick"
          "stats"
        ];
      }
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
