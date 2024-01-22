{...}: let
  hostname = "home-server";
in {
  imports = [
    ../../shared.nix
    ../shared
    ../shared/blocky.nix
    ../users/admin.nix
  ];

  system.stateVersion = "23.11";

  networking.hostName = hostname;
  networking.interfaces.ens160.useDHCP = true;
}
