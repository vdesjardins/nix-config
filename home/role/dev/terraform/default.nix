{ pkgs, ... }: {
  imports = [ ../../../program/terraform ];

  home.packages = with pkgs; [
    terraform_0_15
    terraform-ls
    tflint
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    tfsec
  ];
}
