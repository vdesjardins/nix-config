{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.make = true;

  home.packages = with pkgs; [checkmake];
}
