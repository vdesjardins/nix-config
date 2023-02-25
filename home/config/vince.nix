{
  home-manager,
  pkgs,
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    ../modules
    (import ../users/vince.nix {xsession = true;})
    {
      home = {
        username = "vince";
        homeDirectory = "/home/vince";
        stateVersion = "21.05";
      };
    }
  ];
}
