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
    ../shared/boot.nix
    ../shared/bookmarks-backup.nix
    ../shared/repwise-backup.nix
    ../shared/networking.nix
    ../shared/debugging.nix
    ../shared/desktop.nix
    ../shared/amd.nix
    ../shared/wayland.nix
    ../shared/greetd.nix
    ../shared/pipewire.nix
    ../shared/printing.nix
    ../shared/gaming.nix
    ../shared/wifi.nix
    ./services.nix
    (../users + "/${username}.nix")
  ];

  system.stateVersion = "24.11";

  networking.hostName = hostname;

  # Provide the Xfconf D-Bus service for Home Manager's Thunar settings.
  programs.xfconf.enable = true;

  # Permit private, unprivileged FUSE mounts (e.g. vince's Google Drive).
  programs.fuse.enable = true;

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
