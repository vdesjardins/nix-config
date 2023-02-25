{pkgs, ...}: {
  programs.myNeovim.lang.zig = true;

  home.packages = with pkgs; [unstable.zig];
}
