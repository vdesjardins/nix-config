{ pkgs, ... }: {
  imports = [ ../../../program/terraform ];

  home.packages = with pkgs; [
    unstable.terraform
    unstable.terraform-ls
    unstable.tflint
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    unstable.tfsec
  ];
}
