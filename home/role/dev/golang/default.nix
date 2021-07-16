{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    gocode
    gopls
  ];
  # TODO: fix this. not working anymore
  # xdg.configFile."nvim/UltiSnips/go.snippets".source = ./snippets/go.snippets;
}
