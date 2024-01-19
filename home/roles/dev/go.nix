{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.go = true;

  home.packages = with pkgs; [
    delve
    unstable.go_1_19
    gocode
    gopls
    unstable.gokart
  ];
}
