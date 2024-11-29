{pkgs, ...}: {
  home.packages = with pkgs; [
    nodePackages.fixjson
    jiq
    jq
    gron
  ];
}
