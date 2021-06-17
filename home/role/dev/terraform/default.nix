{ config, lib, pkgs, ... }: {
  imports = [ ../../../program/terraform ];

  home.packages = with pkgs; [
    terraform-ls
    terraform-lsp
    terraform-compliance
    terraform-docs
    terraform-landscape
    terraformer
    tflint
    tfsec
  ];

  programs.neovim = { plugins = with pkgs.vimPlugins; [ vim-terraform ]; };
}
