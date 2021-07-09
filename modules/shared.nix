# This file contains configuration that is shared across all hosts.
{ pkgs, lib, options, ... }: {
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://vdesjardins.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "vdesjardins.cachix.org-1:o0VX1pROMi3RAULObu4+OOCIZFpcKAR01Oxef2CdUx4="
    ];

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  programs = {
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  fonts = (
    lib.mkMerge [
      # NOTE: Remove this condition when `nix-darwin` aligns with NixOS
      (
        if (builtins.hasAttr "fontDir" options.fonts) then {
          fontDir.enable = true;
        } else {
          enableFontDir = true;
        }
      )
      { fonts = with pkgs; [ hack-font ]; }
    ]
  );
}
