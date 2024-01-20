{...}: let
  username = "vince";
  hostname = "dev-vm";
in {
  imports = [
    ../../shared.nix
    ../hardware/vm-aarch64.nix
    ../shared
    ../shared/desktop.nix
    ../shared/vm.nix
    ../shared/greetd.nix
    ../shared/pipewire.nix
    (../users + "/${username}.nix")
    {
      system.stateVersion = "23.11";
    }
  ];

  networking.hostName = hostname;
  networking.interfaces.ens160.useDHCP = true;

  virtualisation.vmware.guest.enable = true;

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
