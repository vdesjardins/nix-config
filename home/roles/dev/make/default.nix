{ pkgs, ... }: {
  programs.myNeovim.lang.make = true;

  home.packages = with pkgs; [ checkmake ];
}
