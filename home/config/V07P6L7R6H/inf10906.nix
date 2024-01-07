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
    (import ../../users/inf10906.nix {})
    {
      home = {
        username = "inf10906";
        homeDirectory = "/Users/inf10906";
        stateVersion = "23.11";
      };
    }
    nix-index-database.hmModules.nix-index
  ];
}
