# This file contains configuration that is shared across all hosts.
{ pkgs, lib, options, ... }: {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    binaryCaches = [ "https://cache.nixos.org/" ];
    binaryCachePublicKeys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  programs = {
    zsh = {
      enable = true;
      promptInit = "";
    };
  };

  fonts = (lib.mkMerge [
    # NOTE: Remove this condition when `nix-darwin` aligns with NixOS
    (if (builtins.hasAttr "fontDir" options.fonts) then {
      fontDir.enable = true;
    } else {
      enableFontDir = true;
    })
    { fonts = with pkgs; [ hack-font ]; }
  ]);
}
