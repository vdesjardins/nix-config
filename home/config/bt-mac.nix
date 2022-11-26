{ home-manager, pkgs }:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    (import ../users/vince.nix { })
    {
      home = {
        username = "vince";
        homeDirectory = "/Users/vince";
        stateVersion = "21.05";
      };
    }
  ];
}
