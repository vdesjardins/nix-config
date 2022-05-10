{ config, pkgs, ... }:
{
  # We require 5.14+ for VMware Fusion on M1.
  # Can't use latest to build because kernel security fixes make it unbootable
  # https://github.com/mitchellh/nixos-config/issues/22
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_15.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
        sha256 = "sha256-WBIhNPJhP8uyALsjme8hF4UhZqjhHu1LYyqGsgtrvjo=";
      };
      version = "5.15.26";
      modDirVersion = "5.15.26";
    };
  });
}
