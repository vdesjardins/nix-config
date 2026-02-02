{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.aws;
in {
  options.roles.ops.aws = {
    enable = mkEnableOption "ops.aws";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      amazon-ecr-credential-helper
      aws-vault
      awslogs
      eks-node-viewer
      eksctl
      # TODO: Re-enable ssm-session-manager-plugin once nixpkgs fixes vendor issues
      # ssm-session-manager-plugin
    ];

    modules.shell.tools.awscli2.enable = true;
    modules.shell.tools.granted.enable = true;
  };
}
