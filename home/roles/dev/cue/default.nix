{pkgs, ...}: {
  programs.myNeovim.lang.cue = true;

  home.packages = with pkgs; [
    cue
    cuetools
  ];
}
