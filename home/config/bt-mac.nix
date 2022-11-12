{ home-manager, pkgs }:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  system = "aarch64-darwin";
  username = "vincentdesjardins";
  homeDirectory = "/Users/vincentdesjardins";
  stateVersion = "21.05";
  configuration = import ../users/vincentdesjardins.nix { };
  extraModules = [ ../modules ];

  # TODO: change to this when hm 22.11 is released
  # inherit pkgs;
  # modules = [
  #   ../modules
  #   (import ../users/vince.nix { })
  #   {
  #     home = {
  #       username = "vince";
  #       homeDirectory = "/Users/vince";
  #       stateVersion = "21.05";
  #     };
  #   }
  # ];
}
