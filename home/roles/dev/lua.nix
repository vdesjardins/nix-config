{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.lua = true;

  home.packages = with pkgs; [
    lua5_3
  ];
}
