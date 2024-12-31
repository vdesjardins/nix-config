{pkgs, ...}: let
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
    ../shared/debugging.nix
    ../shared/desktop.nix
    ../shared/wayland.nix
    ../shared/greetd.nix
    ../shared/pipewire.nix
    ../shared/gaming.nix
    ../shared/wifi.nix
    (../users + "/${username}.nix")
  ];

  system.stateVersion = "23.11";

  networking.hostName = hostname;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-partlabel/root";
      preLVM = true;
    };
  };
}
