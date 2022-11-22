{ home-manager, pkgs }:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  system = "x86_64-linux";
  username = "vincent_desjardins";
  homeDirectory = "/Users/vincent_desjardins";
  stateVersion = "21.05";
  configuration = import ../users/vincent_desjardins.nix { };
  extraModules = [ ../modules ];

  # TODO: change to this when hm 22.11 is released
  # inherit pkgs;
  # modules = [
  #   ../modules
  #   ../users/vincent_desjardins.nix
  #   {
  #     home = {
  #       username = "vincent_desjardins";
  #       homeDirectory = "/home/vincent_desjardins";
  #       stateVersion = "21.05";
  #     };
  #   }
  # ];
}
