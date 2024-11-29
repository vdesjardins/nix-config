{pkgs, ...}: {
  home.packages = with pkgs; [
    conftest
  ];
}
