{
  home-manager,
  pkgs,
  nix-index-database,
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    (import ../users/vincent_desjardins.nix {})
    {
      home = {
        username = "vincent_desjardins";
        homeDirectory = "/home/vincent_desjardins";
        stateVersion = "23.11";
      };
    }
    nix-index-database.hmModules.nix-index
  ];
}
