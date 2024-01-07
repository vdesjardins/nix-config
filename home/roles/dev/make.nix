{pkgs, ...}: {
  programs.nvim.lang.make = true;

  home.packages = with pkgs; [checkmake];
}
