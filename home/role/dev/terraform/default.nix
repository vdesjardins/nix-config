{ pkgs, ... }: {
  imports = [ ../../../program/terraform ];

  home.packages = with pkgs; [
    unstable.terraform
    terraform-ls
    tflint
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    tfsec
  ];
}
