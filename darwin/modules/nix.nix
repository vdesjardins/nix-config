{ pkgs, inputs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };

  services.nix-daemon.enable = true;
}
