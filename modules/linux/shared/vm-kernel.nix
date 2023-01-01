{ config, pkgs, ... }:
{
  # We require 5.14+ for VMware Fusion on M1.
  # Can't use latest to build because kernel security fixes make it unbootable
  # https://github.com/mitchellh/nixos-config/issues/22
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
