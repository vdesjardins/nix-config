{pkgs, ...}: {
  programs.nvim.lang.python = true;

  home.packages = with pkgs; [poetry];
}
