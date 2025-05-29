{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.terraform;
in {
  options.roles.dev.terraform = {
    enable = mkEnableOption "dev.terraform";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.terraform.enable = true;

    home.packages = with pkgs; [
      hcledit
      inframap
      terraform-compliance
      terraform-docs
      terraform-landscape
      terraformer
      infracost
      terragrunt
      tflint
      tfsec
    ];
  };
}
