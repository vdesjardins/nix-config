{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.zig = true;

  home.packages = with pkgs; [unstable.zig];
}
