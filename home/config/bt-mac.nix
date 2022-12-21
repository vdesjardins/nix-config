{ home-manager, pkgs }:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    (import ../users/vincentdesjardins.nix { })
    {
      home = {
        username = "vincentdesjardins";
        homeDirectory = "/Users/vincentdesjardins";
        stateVersion = "21.05";
      };
    }
  ];
}
