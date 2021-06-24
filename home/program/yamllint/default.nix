{ config, pkgs, ... }: {
  xdg.configFile."yamllint/config".source = ./config.yaml;
}
