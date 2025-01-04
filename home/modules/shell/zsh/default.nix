{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
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

      plugins = [
        {
          name = "enhancd";
          file = "init.sh";
          src = pkgs.fetchFromGitHub {
            owner = "babarot";
            repo = "enhancd";
            rev = "c6967f7f70f18991a5f9148996afffc0d3ae76e4";
            sha256 = "sha256-p7ZG4NC9UWa55tPxYAaFocc0waIaTt+WO6MNearbO0U=";
          };
        }
      ];

      initExtraBeforeCompInit = ''
        fpath=( ${config.xdg.configHome}/zsh/functions "''${fpath[@]}" )
        autoload -Uz $fpath[1]/*
      '';

      initExtra = ''
        source ${config.home.homeDirectory}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        export ENHANCD_FILTER=fzf

        function take() {
          mkdir -p $1
          cd $1
        }

        bindkey \^U backward-kill-line

        if [[ -f ~/.zshrc.local ]]; then
          source ~/.zshrc.local
        fi

        GLOBALIAS_FILTER_VALUES=(ls ll)

        export PATH=$HOME/.nix-profile/bin:$PATH
      '';
    };

    home.sessionPath = [
      "$HOME/.local/bin:$PATH"
    ];
  };
}
