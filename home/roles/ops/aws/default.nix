{pkgs, ...}: {
  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    aws-find-profile
    aws-vault
    awslogs
    eks-node-viewer
    eksctl
    ssm-session-manager-plugin
  ];
  imports = [
    ../../../programs/awscli
    ../../../programs/granted
  ];
}
