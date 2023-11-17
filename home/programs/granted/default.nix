{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  home.packages = with pkgs; [
    unstable.granted
  ];
}
