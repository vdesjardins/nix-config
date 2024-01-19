{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.bash = true;

  programs.bash.enable = true;

  home.packages = with pkgs; [
    bash
    bats
  ];
}
