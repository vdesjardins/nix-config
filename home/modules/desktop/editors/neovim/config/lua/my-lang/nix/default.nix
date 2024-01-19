{pkgs, ...}: {
  packages = with pkgs; [
    alejandra
    rnix-lsp
    statix
  ];
}
