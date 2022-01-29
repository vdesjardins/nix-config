{ pkgs, ... }:
{
  home.packages = with pkgs; [
    delve
    go_1_17
    gocode
    gopls
    unstable.gokart
  ];
  # TODO: fix this. not working anymore
  # xdg.configFile."nvim/UltiSnips/go.snippets".source = ./snippets/go.snippets;
}
