{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.python = true;

  home.packages = with pkgs; [poetry];
}
