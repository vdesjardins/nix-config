{ pkgs, ... }:
{
  programs.myNeovim.lang.go = true;

  home.packages = with pkgs; [
    delve
    unstable.go_1_18
    gocode
    gopls
    unstable.gokart
  ];
  # TODO: fix this. not working anymore
  # xdg.configFile."nvim/UltiSnips/go.snippets".source = ./snippets/go.snippets;
}
