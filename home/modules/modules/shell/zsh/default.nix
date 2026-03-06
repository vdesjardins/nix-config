{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOrder mkMerge;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh-syntax-highlighting
      zsh-zhooks
    ];

    programs.zsh = {
      inherit (cfg) enable;

      dotDir = "${config.xdg.configHome}/zsh";

      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      syntaxHighlighting = {
        enable = true;
      };

      history = {
        size = 30000;
        save = 30000;
        ignorePatterns = [];
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        extended = true;
        share = true;
      };

      historySubstringSearch = {
        enable = true;
      };

      shellGlobalAliases = {
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
        DN = "/dev/null";
        EG = "|& egrep";
        EL = "|& less";
        ET = "|& tail";
      };

      oh-my-zsh = {
        enable = true;
        plugins = ["globalias"];
      };

      plugins = [];

      initContent = mkMerge [
        (mkOrder 550 ''
          fpath=( ${config.xdg.configHome}/zsh/functions "''${fpath[@]}" )
          autoload -Uz $fpath[1]/*
        '')
        (mkOrder 1000 ''
          source ${config.home.homeDirectory}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

          function take() {
            mkdir -p $1
            cd $1
          }

          bindkey \^U backward-kill-line

          if [[ -f ~/.zshrc.local ]]; then
            source ~/.zshrc.local
          fi

          GLOBALIAS_FILTER_VALUES=(ls ll cd grep)

          export PATH=$HOME/.nix-profile/bin:$PATH
        '')
      ];
    };

    home.sessionPath = [
      "$HOME/.local/bin:$PATH"
    ];
  };
}
