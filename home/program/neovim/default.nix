{ pkgs, ... }:
{
  programs.myNeovim = {
    enable = true;
    package = pkgs.neovim-nightly;
  };
}
