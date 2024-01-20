{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.bat;
in {
  options.modules.shell.tools.bat = {
    enable = mkEnableOption "bat pager";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [unixtools.col];

    programs.bat = {
      inherit (cfg) enable;

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
        "-- -h" = "-h 2>&1 | bat --language=help --paging=auto --style=plain";
        "-- --help" = "--help 2>&1 | bat --language=help --paging=auto --style=plain";
      };
    };

    home.sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat --paging=always -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
