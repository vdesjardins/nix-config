{pkgs, ...}: {
  nix = {
    optimise.automatic = true;

    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      keep-going = true;
      experimental-features = ["nix-command" "flakes" "ca-derivations"];
      keep-derivations = true;
      keep-outputs = true;

      trusted-users = ["@wheel" "root"];

      fallback = true;
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than +5";
    };

    package = pkgs.nixVersions.nix_2_28;
  };

  environment.systemPackages = with pkgs; [
    nixVersions.nix_2_28
  ];
}
