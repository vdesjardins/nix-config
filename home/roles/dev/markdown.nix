{pkgs, ...}: {
  home.packages = with pkgs; [
    glow # renders markdown on command line
  ];
}
