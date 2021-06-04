{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    gocode
    gopls
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      coc-go
    ];
  };

  # TODO: fix this. not working anymore
  # xdg.configFile."nvim/UltiSnips/go.snippets".source = ./snippets/go.snippets;
}
