{pkgs, ...}: {
  programs.nvim.lang.json = true;

  home.packages = with pkgs; [
    nodePackages.fixjson
    jiq
    jq
    gron
  ];
}
