{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  xdg.configFile."zellij/layouts".source = ./layouts;
}
