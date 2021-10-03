{ pkgs, ... }:
{
  home.packages = with pkgs; [ eksctl ssm-session-manager-plugin aws-find-profile ];
  imports = [
    ../../../program/awscli
  ];
}
