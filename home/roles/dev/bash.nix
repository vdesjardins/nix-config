{pkgs, ...}: {
  programs.nvim.lang.bash = true;

  programs.bash.enable = true;

  home.packages = with pkgs; [
    bash
    bats
  ];
}
