{
  home-manager,
  pkgs,
  nix-index-database,
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    (import ../users/vince.nix {xsession = true;})
    {
      home = {
        username = "vince";
        homeDirectory = "/home/vince";
        stateVersion = "21.05";
      };
    }
    nix-index-database.hmModules.nix-index
  ];
}
