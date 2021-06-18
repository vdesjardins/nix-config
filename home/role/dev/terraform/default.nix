{ config, lib, pkgs, ... }: {
  imports = [ ../../../program/terraform ];

  home.packages = with pkgs; [
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    tfsec
  ];

  programs.neovim.enableTerraform = true;
}
