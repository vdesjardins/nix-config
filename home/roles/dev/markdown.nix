{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.markdown = true;

  home.packages = with pkgs; [
    glow # renders markdown on command line
  ];
}
