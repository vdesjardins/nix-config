{pkgs, ...}: {
  modules.shell.tools.terraform.enable = true;

  modules.desktop.editors.neovim.lang.terraform = true;

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
