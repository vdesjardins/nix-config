{ config, lib, pkgs, ... }: {
  home.packages = with pkgs;
    [ rustup rust-analyzer crate2nix ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [ coc-rust-analyzer rust-vim ];
  };
}
