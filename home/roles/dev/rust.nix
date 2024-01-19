{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.rust = true;

  home.packages = with pkgs; [crate2nix rust-bin.stable.latest.default];
}
