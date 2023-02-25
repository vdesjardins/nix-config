{
  home-manager,
  pkgs,
  nix-index-database,
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    (import ../users/vince.nix {})
    {
      home = {
        username = "vince";
        homeDirectory = "/Users/vince";
        stateVersion = "21.05";
      };
    }
    nix-index-database.hmModules.nix-index
  ];
}
