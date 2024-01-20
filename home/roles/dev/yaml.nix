{
  pkgs,
  lib,
  ...
}: {
  modules.desktop.editors.neovim.lang.yaml = true;

  home.packages = with pkgs; [
    yamllint
  ];

  modules.dev.yamllint.enable = true;
}
