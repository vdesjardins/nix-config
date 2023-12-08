{
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = with pkgs; [unixtools.col];

  programs.bat = {
    enable = true;

    config = {
      # [theme]
      theme = "tokyonight-storm";
      paging = "never";
    };

    themes = {
      tokyonight-storm = {
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim"; # Bat uses sublime syntax for its themes
          rev = "f247ee700b569ed43f39320413a13ba9b0aef0db";
          sha256 = "sha256-axjZVZOI+WIv85FfMG+lxftDKlDIw/HzQKyJVFkL33M=";
        };
        file = "extras/sublime/tokyonight_storm.tmTheme";
      };
    };
  };

  programs.zsh = {
    shellAliases = {cat = "bat";};
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
