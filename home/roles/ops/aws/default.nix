{pkgs, ...}: {
  home.packages = with pkgs; [
    amazon-ecr-credential-helper
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
