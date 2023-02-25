{pkgs, ...}: {
  packages = with pkgs; [fenix.rust-analyzer];
}
