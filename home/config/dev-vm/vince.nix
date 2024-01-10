{
  home-manager,
  nix-index-database,
  nixpkgs,
  pkgsConfig,
  utils,
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = utils.lib.system.aarch64-linux;
    inherit (pkgsConfig) config overlays;
  };
  modules = [
    ../../modules
    ../../users/vince-vm.nix
    {
      home = {
        username = "vince";
        homeDirectory = "/home/vince";
        stateVersion = "23.11";
      };
    }
    nix-index-database.hmModules.nix-index
  ];
}
