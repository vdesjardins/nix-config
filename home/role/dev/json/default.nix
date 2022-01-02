{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode-langservers-extracted
    nodePackages.fixjson
    jiq
    jq
    gron
  ];
}
