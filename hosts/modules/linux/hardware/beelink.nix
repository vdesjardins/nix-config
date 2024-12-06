{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
    initrd.kernelModules = ["dm-snapshot"];
    kernelModules = ["amdgpu" "kvm-amd"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/88d4e071-b43d-4233-92f6-2a9bc50115ba";
      fsType = "ext4";
    };

    "/nix/store" = {
      device = "/dev/disk/by-uuid/82f59801-74a0-49e8-9906-35ee038928e7";
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/aa743e29-11eb-4539-b4ce-1c7fac590e5a";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8C34-D0CA";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/52ca756a-3f82-47cd-ad30-e59edbff9a34";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
