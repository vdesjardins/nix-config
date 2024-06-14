{pkgs, ...}: {
  home.packages = with pkgs; [unstable.mission-center];
}
