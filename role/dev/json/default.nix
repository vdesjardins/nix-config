{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [ nodePackages.prettier nodePackages.vscode-json-languageserver-bin ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      coc-json
    ];
  };
}
