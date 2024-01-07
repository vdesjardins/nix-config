{
  home-manager,
  nix-index-database,
  pkgs,
  pkgsConfig,
  utils,
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    system = utils.lib.system.aarch64-darwin;
    inherit (pkgsConfig) config overlays;
  };
  modules = [
    ../../modules
    (import ../../users/vince.nix {})
    {
      home = {
        username = "vince";
        homeDirectory = "/Users/vince";
        stateVersion = "23.11";
      };
    }
    nix-index-database.hmModules.nix-index
  ];
}
