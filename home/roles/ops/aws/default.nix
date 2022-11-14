{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awslogs
    aws-find-profile
    #aws-sso-util
    aws-vault
    eksctl
    ssm-session-manager-plugin
  ];
  imports = [
    ../../../programs/awscli
  ];
}
