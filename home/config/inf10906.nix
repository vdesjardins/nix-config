{ home-manager, pkgs }:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    ../users/inf10906.nix
    {
      home = {
        username = "inf10906";
        homeDirectory = "/Users/inf10906";
        stateVersion = "21.05";
      };
    }
  ];
}
