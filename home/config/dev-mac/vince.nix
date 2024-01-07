{
  home-manager,
  nix-index-database,
  pkgsConfig,
  utils,
  nixpkgs,
  ...
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
