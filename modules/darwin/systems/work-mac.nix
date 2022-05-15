{ darwin, inputs, pkgsConfig }:
let
  username = "inf10906";
  hostname = "C02G32U9MD6T";
in
darwin.lib.darwinSystem {
  system = "x86_64-darwin";
  inherit inputs;
  modules = [
    ../shared
    {
      homebrew.casks = [
        "karabiner-elements"
        "raycast"
        "Rectangle"
        "flameshot"
        "middleclick"
      ];
    }
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
