{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.node2nix
  ];
}
