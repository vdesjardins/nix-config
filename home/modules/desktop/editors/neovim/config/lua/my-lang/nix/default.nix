{pkgs, ...}: {
  packages = with pkgs; [
    alejandra
    statix
    nixd
  ];
}
