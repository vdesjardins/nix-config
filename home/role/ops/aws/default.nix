{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awslogs
    aws-find-profile
    eksctl
    ssm-session-manager-plugin
  ];
  imports = [
    ../../../program/awscli
  ];
}
