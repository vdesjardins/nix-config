{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
