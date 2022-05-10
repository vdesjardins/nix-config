{ home-manager, pkgsConfig }:
home-manager.lib.homeManagerConfiguration
{
  system = "x86_64-darwin";
  stateVersion = "21.05";
  username = "inf10906";
  homeDirectory = "/Users/inf10906";
  extraModules = [ ../modules ];
  configuration = import ../users/inf10906.nix {
    pkgs = pkgsConfig;
  };
}
