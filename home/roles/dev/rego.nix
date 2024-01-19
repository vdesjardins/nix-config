{pkgs, ...}: {
  modules.desktop.editors.neovim.lang.rego = true;

  home.packages = with pkgs; [
    conftest
  ];
}
