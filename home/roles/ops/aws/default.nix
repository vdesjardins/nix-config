{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #aws-sso-util
    amazon-ecr-credential-helper
    aws-find-profile
    aws-vault
    awslogs
    eksctl
    ssm-session-manager-plugin
  ];
  imports = [
    ../../../programs/awscli
    ../../../programs/granted
  ];
}
