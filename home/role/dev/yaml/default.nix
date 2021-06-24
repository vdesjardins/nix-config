{ config, lib, pkgs, ... }: {
  programs.neovim.enableYaml = true;
  imports = [
    ../../../program/yamllint
  ];
}
