{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.json = true;

  home.packages = with pkgs; [
    nodePackages.fixjson
    jiq
    jq
    gron
  ];
}
