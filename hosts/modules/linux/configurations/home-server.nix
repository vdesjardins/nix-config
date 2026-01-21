{
  lib,
  nixos-hardware,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;

  hostname = "home-server";
in {
  imports = [
    nixos-hardware.nixosModules.raspberry-pi-4
    ../../shared.nix
    ../../nix.nix
    ../../tailscale.nix
    ../shared
    ../shared/networking.nix
    ../users/admin.nix
  ];

  networking.hostName = hostname;

  networking.firewall.enable = false;

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    vim
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 1024;
    }
  ];

  # hardware = {
  #   raspberry-pi."4".apply-overlays-dtmerge.enable = true;
  #   deviceTree = {
  #     enable = true;
  #     filter = "*rpi-4-*.dtb";
  #   };
  # };

  # HACK for missing kernel module "sun4i-drm" causing build failure
  # More info here: https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  formatConfigs.sd-aarch64 = {config, ...}: {
    # need to override to hadd hdmi_force_unplug to be able to boot without monitor attached.
    sdImage = mkForce {
      compressImage = false;

      populateFirmwareCommands = let
        configTxt = pkgs.writeText "config.txt" ''
          [pi3]
          kernel=u-boot-rpi3.bin
          hdmi_force_hotplug=1

          [pi02]
          kernel=u-boot-rpi3.bin

          [pi4]
          kernel=u-boot-rpi4.bin
          hdmi_force_hotplug=1
          enable_gic=1
          armstub=armstub8-gic.bin

          # Otherwise the resolution will be weird in most cases, compared to
          # what the pi3 firmware does by default.
          disable_overscan=1

          # Supported in newer board revisions
          arm_boost=1

          [cm4]
          # Enable host mode on the 2711 built-in XHCI USB controller.
          # This line should be removed if the legacy DWC2 controller is required
          # (e.g. for USB device mode) or if USB support is not required.
          otg_mode=1

          [all]
          # Boot in 64-bit mode.
          arm_64bit=1

          # U-Boot needs this to work, regardless of whether UART is actually used or not.
          # Look in arch/arm/mach-bcm283x/Kconfig in the U-Boot tree to see if this is still
          # a requirement in the future.
          enable_uart=1

          # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
          # when attempting to show low-voltage or overtemperature warnings.
          avoid_warnings=1
        '';
      in ''
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)

        # Add the config
        cp ${configTxt} firmware/config.txt

        # Add pi3 specific files
        cp ${pkgs.ubootRaspberryPi3_64bit}/u-boot.bin firmware/u-boot-rpi3.bin

        # Add pi4 specific files
        cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin firmware/u-boot-rpi4.bin
        cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-4-b.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-400.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4.dtb firmware/
        cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4s.dtb firmware/
      '';
      populateRootCommands = ''
        mkdir -p ./files/boot
        ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
      '';
    };
  };

  system.stateVersion = "23.11";
}
