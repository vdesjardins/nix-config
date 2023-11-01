{pkgs, ...}: {
  programs.myNeovim.lang.rego = true;

  home.packages = with pkgs; [
    conftest
  ];
}
