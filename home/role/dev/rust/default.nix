{ pkgs, ... }: {
  home.packages = with pkgs; [ crate2nix rust-analyzer rustup ];
}
