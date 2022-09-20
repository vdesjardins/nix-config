{ pkgs, ... }: {
  programs.myNeovim.lang.python = true;

  home.packages = with pkgs; [ poetry ];
}
