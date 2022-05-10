{ home-manager, pkgsConfig }:
home-manager.lib.homeManagerConfiguration {
  system = "aarch64-darwin";
  stateVersion = "21.05";
  username = "vince";
  homeDirectory = "/Users/vince";
  extraModules = [ ../modules ];
  configuration = import ../users/vince.nix {
    pkgs = pkgsConfig;
  };
}
