{pkgs, ...}: {
  modules.shell.tools.terraform.enable = true;

  home.packages = with pkgs; [
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
}
