{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.cue = true;

  home.packages = with pkgs; [
    cue
    cuetools
  ];
}
