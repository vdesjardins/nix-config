{
  pkgs,
  lib,
  ...
}: {
  modules.desktop.editors.neovim.lang.yaml = true;

  home.packages = with pkgs; [
    yamllint
  ];

  programs.yamllint.enable = true;
}
