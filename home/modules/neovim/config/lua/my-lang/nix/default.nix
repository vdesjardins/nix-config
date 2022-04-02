{ pkgs, ... }:
{
  packages = with pkgs; [
    rnix-lsp
    statix
  ];
}
