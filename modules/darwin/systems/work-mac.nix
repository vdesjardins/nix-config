{ darwin, home-manager, inputs, pkgsConfig }:
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
      networking.hostName = hostname;

      imports = [
        ../users/${username}.nix
      ];
    }
    { users.knownUsers = [ username ]; }
    home-manager.darwinModule
    { nixpkgs = pkgsConfig; }
    ../../../home/users/${username}.nix
  ];
}
