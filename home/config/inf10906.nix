{
  home-manager,
  pkgs,
  nix-index-database,
}:
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
    nix-index-database.hmModules.nix-index
  ];
}
