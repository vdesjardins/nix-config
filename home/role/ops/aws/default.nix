{ pkgs, ... }:
{
  home.packages = with pkgs; [ eksctl ];
  imports = [
    ../../../program/awscli
  ];
}
