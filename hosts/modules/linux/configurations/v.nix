{...}: let
  username = "vince";
  hostname = "v";
in {
  imports = [
    ../../shared.nix
    ../../nix.nix
    ../../desktop.nix
    ../../tailscale.nix
    ../hardware/v.nix
    ../shared
    ../shared/acme.nix
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
    ../shared/opencode.nix
    ./services.nix
    (../users + "/${username}.nix")
  ];

  system.stateVersion = "24.11";

  networking.hostName = hostname;

  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd" "noatime"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/swap".options = ["noatime"];
  };

  swapDevices = [{device = "/swap/swapfile";}];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };
}
