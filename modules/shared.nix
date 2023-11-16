# This file contains configuration that is shared across all hosts.
{pkgs, ...}: {
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://vdesjardins.cachix.org"
        "https://cache.ngi0.nixos.org/" # ca-derivations cache
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "vdesjardins.cachix.org-1:o0VX1pROMi3RAULObu4+OOCIZFpcKAR01Oxef2CdUx4="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    package = pkgs.unstable.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      keep-derivations = true
      keep-outputs = true
    '';
  };

  programs = {
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  time.timeZone = "America/New_York";

  fonts.fonts = [
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    pkgs.unstable.monaspace
  ];
}
