{ lib, pkgs, ... }:

with lib;

{
  home.packages = with pkgs; [ unixtools.col ];

  programs.bat = {
    enable = true;

    config = {
      theme = "Sublime Snazzy";
      paging = "never";
    };
  };

  programs.zsh = {
    shellAliases = { cat = "bat"; };
    shellGlobalAliases = {
      BJ = "|& bat -ljson";
      BY = "|& bat -lyaml";
      BT = "|& bat";
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat --paging=always -l man -p'";
  };
}
