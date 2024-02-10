{pkgs, ...}: {
  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    aws-vault
    awslogs
    eks-node-viewer
    eksctl
    ssm-session-manager-plugin
  ];

  modules.shell.tools.awscli2.enable = true;
  modules.shell.tools.granted.enable = true;
}
