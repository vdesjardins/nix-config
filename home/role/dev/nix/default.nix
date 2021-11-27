{ pkgs, ... }:
{
  # TODO: not working on aarch64
  imports = [
    ../../../program/nix-index
  ];

  home.packages = with pkgs; [
    rnix-lsp
    nixpkgs-fmt
    nix-linter
    nix-tree
    nix-prefetch
  ] ++ lib.optionals stdenv.isLinux [
    cntr
  ];
}
