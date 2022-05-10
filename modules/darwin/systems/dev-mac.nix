{ darwin, inputs, pkgsConfig }:
let
  username = "vince";
  hostname = "dev-mac";
in
darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  inherit inputs;
  modules = [
    ../shared
    {
      homebrew.casks = [
        "karabiner-elements"
        "raycast"
        "google-chrome"
        "Rectangle"
        "docker"
        "homebrew/cask-versions/vmware-fusion-tech-preview"
        "middleclick"
      ];
    }
    (import ../services/spotifyd { device_name = hostname; })
    {
      networking.hostName = hostname;

      imports = [
        (../users + "/${username}.nix")
      ];
    }
    { users.knownUsers = [ username ]; }
    { nixpkgs = pkgsConfig; }
  ];
}
