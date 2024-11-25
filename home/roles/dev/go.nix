{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.go = true;

  home.packages = with pkgs; [
    delve
    go_1_22
    gopls
    gokart
  ];
}
