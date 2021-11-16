{ home-manager, pkgsConfig }:
home-manager.lib.homeManagerConfiguration {
  system = "x86_64-linux";
  stateVersion = "21.05";
  username = "vincent_desjardins";
  homeDirectory = "/home/vincent_desjardins";
  configuration = import ../users/vincent_desjardins.nix {
    pkgs = pkgsConfig;
  };
}
