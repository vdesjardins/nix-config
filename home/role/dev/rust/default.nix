{ pkgs, ... }: {
  home.packages = with pkgs; [ crate2nix unstable.rust-analyzer unstable.rustup ];
}
