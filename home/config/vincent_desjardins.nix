{ home-manager, pkgs }:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    ../users/vincent_desjardins.nix
    {
      home = {
        username = "vincent_desjardins";
        homeDirectory = "/home/vincent_desjardins";
        stateVersion = "21.05";
      };
    }
  ];
}
