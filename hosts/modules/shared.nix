# This file contains configuration that is shared across all hosts.
{
  pkgs,
  lib,
  stdenv,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (pkgs) stdenv;
  inherit (stdenv) isDarwin isLinux;
in {
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://vdesjardins.cachix.org"
        "https://cache.ngi0.nixos.org/" # ca-derivations cache
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "vdesjardins.cachix.org-1:o0VX1pROMi3RAULObu4+OOCIZFpcKAR01Oxef2CdUx4="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      keep-going = true;
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;

      trusted-users = ["@wheel" "root"];

      fallback = true;
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    package = pkgs.unstable.nixVersions.stable;
  };

  programs = {
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  time.timeZone = "America/New_York";
}
