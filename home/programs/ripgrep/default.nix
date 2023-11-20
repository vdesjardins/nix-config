{
  config,
  pkgs,
  lib,
  ...
}: let
  # TODO: refactor after hm 23.11 release
  configPath = "${config.xdg.configHome}/ripgrep/ripgreprc";
  arguments = [
    "--max-columns=150"
    "--max-columns-preview"
    "--hidden"
    "--type-add=zshrc:*.zsh*"
    "--type-add=bashrc:*.sh*"
    "--type-add=automake:*makefile.in*"
    "--glob=!git/*"
    "--glob=!.git/*"
    "--ignore-case"
  ];
in {
  home.packages = [pkgs.ripgrep];

  home.file."${configPath}".text = lib.concatLines arguments;

  home.sessionVariables."RIPGREP_CONFIG_PATH" = configPath;
}
