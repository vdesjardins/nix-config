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
      eza
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
            rev = "8b1f00ef9f55f5820f789375db90f3774514f0cc";
            sha256 = "sha256-WDBCUgeMx8P6mgvy4CxpIKZYym4vq+aKtG9GUiKxyFU=";
          };
        }
      ];

      initExtraBeforeCompInit = ''
        fpath=( ${config.xdg.configHome}/zsh/functions "''${fpath[@]}" )
        autoload -Uz $fpath[1]/*
      '';

      initExtra = ''
        source ${config.home.homeDirectory}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        export ENHANCD_FILTER="fzf --preview 'eza -al --tree --level 1 --group-directories-first --git-ignore \
          --header --git --no-user --no-time --no-filesize --no-permissions {}' \
          --preview-window right,50% --height 35% --reverse --ansi"

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
