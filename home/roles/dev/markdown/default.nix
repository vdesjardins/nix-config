{pkgs, ...}: {
  programs.myNeovim.lang.markdown = true;

  home.packages = with pkgs; [
    glow # renders markdown on command line
  ];
}
