{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    nodePackages.yaml-language-server
    yamllint
  ];

  imports = [
    ../../../program/yamllint
  ];
}
