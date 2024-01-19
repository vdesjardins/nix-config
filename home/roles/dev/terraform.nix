{pkgs, ...}: {
  programs.terraform.enable = true;

  modules.desktop.editors.neovim.lang.terraform = true;

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
