{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.shell.tools.bat;
in {
  options.modules.shell.tools.bat = {
    enable = mkEnableOption "bat pager";
    color-scheme = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [unixtools.col];

    programs.bat = {
      inherit (cfg) enable;

      config = {
        # [theme]
        theme = "custom";
        paging = "never";
      };

      themes = {
        custom = {
          src = cfg.color-scheme;
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
