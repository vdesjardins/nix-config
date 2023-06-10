{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
    package = pkgs.unstable.zellij;
  };
}
