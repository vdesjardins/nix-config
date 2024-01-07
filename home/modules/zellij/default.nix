{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.programs.zellij.enable {
    xdg.configFile."zellij/config.kdl".source = ./config.kdl;
    xdg.configFile."zellij/layouts".source = ./layouts;
  };
}
