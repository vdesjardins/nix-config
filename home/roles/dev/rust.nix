{pkgs, ...}: {
  programs.nvim.lang.rust = true;

  home.packages = with pkgs; [crate2nix rust-bin.stable.latest.default];
}