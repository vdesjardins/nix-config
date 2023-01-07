{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awslogs
    aws-find-profile
    #aws-sso-util
    aws-vault
    eksctl
    granted
    ssm-session-manager-plugin
  ];
  imports = [
    ../../../programs/awscli
  ];
}
