{pkgs, ...}: {
  programs.nvim.lang.zig = true;

  home.packages = with pkgs; [unstable.zig];
}
