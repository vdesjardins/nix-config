{pkgs, ...}: {
  programs.nvim.lang.rego = true;

  home.packages = with pkgs; [
    conftest
  ];
}
