{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unstable.nodePackages.node2nix
  ];
}
