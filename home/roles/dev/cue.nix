{pkgs, ...}: {
  programs.nvim.lang.cue = true;

  home.packages = with pkgs; [
    cue
    cuetools
  ];
}
