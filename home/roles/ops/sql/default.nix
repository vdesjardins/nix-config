{pkgs, ...}: {
  home.packages = with pkgs; [
    usql
  ];
}
