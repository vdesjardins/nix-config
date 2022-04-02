{ pkgs, ... }: {
  imports = [ ../../../program/terraform ];

  programs.myNeovim.lang.terraform = true;

  home.packages = with pkgs; [
    unstable.terraform
    unstable.tflint
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    unstable.tfsec
  ];
}
