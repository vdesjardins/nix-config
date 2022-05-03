{ pkgs, ... }: {
  imports = [ ../../../programs/terraform ];

  programs.myNeovim.lang.terraform = true;

  home.packages = with pkgs; [
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    unstable.infracost
    unstable.terraform
    unstable.tflint
    unstable.tfsec
  ];
}
