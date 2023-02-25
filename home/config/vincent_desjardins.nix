{
  home-manager,
  pkgs,
  nix-index-database,
}:
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
    nix-index-database.hmModules.nix-index
  ];
}
