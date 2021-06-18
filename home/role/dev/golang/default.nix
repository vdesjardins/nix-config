{ config, lib, pkgs, ... }:
{
  programs.neovim.enableGolang = true;

  # TODO: fix this. not working anymore
  # xdg.configFile."nvim/UltiSnips/go.snippets".source = ./snippets/go.snippets;
}
