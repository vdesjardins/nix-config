{pkgs, ...}: {
  packages = with pkgs; [rust-bin.stable.latest.rust-analyzer];
}
