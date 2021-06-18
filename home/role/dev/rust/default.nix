{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [ crate2nix ];

  programs.neovim.enableRust = true;
}
