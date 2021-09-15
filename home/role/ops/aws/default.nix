{ pkgs, ... }:
{
  home.packages = with pkgs; [ eksctl ssm-session-manager-plugin ];
  imports = [
    ../../../program/awscli
  ];
}
