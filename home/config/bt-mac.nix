{
  home-manager,
  pkgs,
  nix-index-database,
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    (import ../users/vincentdesjardins.nix {})
    {
      home = {
        username = "vincentdesjardins";
        homeDirectory = "/Users/vincentdesjardins";
        stateVersion = "21.05";
      };
    }
    nix-index-database.hmModules.nix-index
  ];
}
