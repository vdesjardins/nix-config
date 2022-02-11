{ pkgs, ... }: {
  home.packages = with pkgs; [ crate2nix fenix.rust-analyzer unstable.rustup ];
}
