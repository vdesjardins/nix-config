{pkgs, ...}: {
  home.packages = with pkgs; [crate2nix rust-bin.stable.latest.default];
}
