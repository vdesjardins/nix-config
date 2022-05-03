{ pkgs, ... }:
{
  # TODO: not working on aarch64
  imports = [
    ../../../programs/nix-index
  ];

  programs.myNeovim.lang.nix = true;

  home.packages = with pkgs; [
    nixpkgs-fmt
    nix-linter
    nix-tree
    nix-prefetch
  ];
}
