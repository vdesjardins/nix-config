{pkgs, ...}: {
  programs.nvim.lang.markdown = true;

  home.packages = with pkgs; [
    glow # renders markdown on command line
  ];
}
