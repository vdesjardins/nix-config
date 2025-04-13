{pkgs, ...}: {
  home.packages = with pkgs; [
    delve
    go
    gopls
    gokart
  ];
}
