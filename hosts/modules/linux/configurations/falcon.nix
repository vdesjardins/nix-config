{...}: let
  username = "vince";
  hostname = "falcon";
in {
  imports = [
    ../../shared.nix
    ../../desktop.nix
    ../../tailscale.nix
    ../hardware/beelink.nix
    ../shared
    ../shared/boot.nix
    ../shared/desktop.nix
    ../shared/greetd.nix
    ../shared/pipewire.nix
    (../users + "/${username}.nix")
  ];

  system.stateVersion = "23.11";

  networking.hostName = hostname;

  networking.networkmanager.enable = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-partlabel/root";
      preLVM = true;
    };
  };
}
