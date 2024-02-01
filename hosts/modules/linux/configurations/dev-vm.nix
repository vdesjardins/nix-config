{...}: let
  username = "vince";
  hostname = "dev-vm";
in {
  imports = [
    ../../shared.nix
    ../../desktop.nix
    ../hardware/vm-aarch64.nix
    ../shared
    ../shared/boot.nix
    ../shared/desktop.nix
    ../shared/vm.nix
    ../shared/greetd.nix
    ../shared/pipewire.nix
    (../users + "/${username}.nix")
  ];

  system.stateVersion = "23.11";

  networking.hostName = hostname;

  virtualisation.vmware.guest.enable = true;

  networking.extraHosts = ''
    192.168.50.2 home-server
  '';

  # Share our host filesystem
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
      "nofail"
    ];
  };
}
