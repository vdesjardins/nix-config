{ pkgs, ... }:
{
  packages = with pkgs; [
    unstable.pyright
  ];
}
