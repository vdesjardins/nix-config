{pkgs, ...}: {
  home.packages = with pkgs; [unstable.jan];
}
