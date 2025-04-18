{...}: let
  username = "vince";
  hostname = "v";
in {
  imports = [
    ../../shared.nix
    ../../desktop.nix
    ../../tailscale.nix
    ../hardware/beelink.nix
    ../shared
    ../shared/boot.nix
    ../shared/networking.nix
    ../shared/debugging.nix
    ../shared/desktop.nix
    ../shared/amd.nix
    ../shared/wayland.nix
    ../shared/greetd.nix
    ../shared/pipewire.nix
    ../shared/gaming.nix
    ../shared/wifi.nix
    (../users + "/${username}.nix")
  ];

  system.stateVersion = "24.11";

  networking.hostName = hostname;
}
