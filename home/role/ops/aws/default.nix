{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awslogs
    aws-find-profile
    #aws-sso-util
    eksctl
    ssm-session-manager-plugin
  ];
  imports = [
    ../../../program/awscli
  ];
}
