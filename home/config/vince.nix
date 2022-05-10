{ home-manager, pkgsConfig }:
home-manager.lib.homeManagerConfiguration {
  system = "aarch64-linux";
  stateVersion = "21.05";
  username = "vince";
  homeDirectory = "/home/vince";
  extraModules = [ ../modules ];
  configuration = import ../users/vince.nix {
    pkgs = pkgsConfig;
    xsession = true;
  };
}
