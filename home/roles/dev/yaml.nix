{
  pkgs,
  lib,
  ...
}: {
  programs.nvim.lang.yaml = true;

  home.packages = with pkgs; [
    yamllint
  ];

  programs.yamllint.enable = true;
}
