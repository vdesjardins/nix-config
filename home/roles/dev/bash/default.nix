{pkgs, ...}: {
  programs.nvim.lang.bash = true;

  home.packages = with pkgs; [
    bash
    bats
  ];
}
