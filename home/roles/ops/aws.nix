{pkgs, ...}: {
  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    aws-vault
    awslogs
    eks-node-viewer
    eksctl
    ssm-session-manager-plugin
  ];

  programs.awscli2.enable = true;
  programs.granted.enable = true;
}
