{pkgs, ...}: {
  programs.myNeovim.lang.bash = true;

  home.packages = with pkgs; [
    bash
    bats
  ];
}
