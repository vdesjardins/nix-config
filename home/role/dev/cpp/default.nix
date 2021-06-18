{ config, lib, pkgs, ... }: {
  programs.neovim.enableCpp = true;

  home.packages = with pkgs; [ gcc poco cmake clang-tools ];
}
