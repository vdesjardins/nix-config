{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.markdown = true;
  modules.desktop.editors.neovim.lang.mermaid = true;

  home.packages = with pkgs; [
    glow # renders markdown on command line
  ];
}
