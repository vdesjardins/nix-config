{pkgs, ...}: {
  home.packages = with pkgs; [unstable.noseyparker];
}
