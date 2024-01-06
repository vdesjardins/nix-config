{pkgs, ...}: {
  imports = [../../../programs/terraform];

  programs.nvim.lang.terraform = true;

  home.packages = with pkgs; [
    inframap
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    unstable.infracost
    unstable.terragrunt
    unstable.tflint
    unstable.tfsec
  ];
}
