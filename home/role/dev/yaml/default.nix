{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [ nodePackages.yaml-language-server yamllint ];

  programs.neovim = { plugins = with pkgs.vimPlugins; [ coc-yaml ]; };
}
