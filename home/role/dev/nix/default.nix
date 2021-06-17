{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt
    rnix-lsp
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };
}
