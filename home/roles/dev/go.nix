{pkgs, ...}: {
  home.packages = with pkgs; [
    delve
    go_1_22
    gopls
    gokart
  ];
}
