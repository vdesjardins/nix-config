{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rnix-lsp
    nixpkgs-fmt
    nix-linter
  ];
}
