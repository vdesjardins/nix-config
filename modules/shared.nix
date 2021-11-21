# This file contains configuration that is shared across all hosts.
{ pkgs, inputs, ... }: {
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://vdesjardins.cachix.org"
      "https://cache.ngi0.nixos.org/"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "vdesjardins.cachix.org-1:o0VX1pROMi3RAULObu4+OOCIZFpcKAR01Oxef2CdUx4="
    ];

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations ca-references
    '';
  };

  programs = {
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  fonts.enableFontDir = true;
  fonts.fonts = [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "VictorMono" ]; })
  ];
}
