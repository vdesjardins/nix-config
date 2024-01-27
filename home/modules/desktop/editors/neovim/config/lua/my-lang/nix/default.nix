{pkgs, ...}: {
  packages = with pkgs; [
    alejandra
    statix
    unstable.nixd
  ];
}
