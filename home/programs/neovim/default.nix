{pkgs, ...}: {
  programs.nvim = {
    enable = true;
    package = pkgs.neovim-nightly;
  };
}
