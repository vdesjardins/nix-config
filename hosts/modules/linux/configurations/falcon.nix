{...}: let
  username = "admin";
  hostname = "falcon";
in {
  imports = [
    ../../shared.nix
    ../../nix.nix
    ../../tailscale.nix
    ../hardware/beelink.nix
    ../shared
    ../shared/boot.nix
    ../shared/networking.nix
    ../shared/amd.nix
    ../shared/acme.nix
    ../shared/podman.nix
    ../shared/omada-controller.nix
    ../shared/it-tools.nix
    ../shared/frigate.nix
    ../shared/home-assistant.nix
    ../shared/mosquitto.nix
    ../shared/victoriametrics.nix
    ../shared/grafana
    ../shared/victorialogs.nix
    ../shared/alloy
    ../shared/cadvisor.nix
    ../users/admin.nix
    (../users + "/${username}.nix")
  ];

  system.stateVersion = "24.11";

  networking.hostName = hostname;

  networking.firewall.enable = false;
}
