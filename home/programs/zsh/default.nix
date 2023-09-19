{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh-syntax-highlighting
  ];

  programs.zsh = {
    enable = true;

    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    # TODO: need 23.11
    # syntaxHighlighting = {
    #   enable = true;
    # };

    history = {
      size = 30000;
      save = 30000;
      ignorePatterns = [];
      # TODO: need 23.11
      # ignoreAllDups = true;
      expireDuplicatesFirst = true;
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
          owner = "b4b4r07";
          repo = "enhancd";
          rev = "c6967f7f70f18991a5f9148996afffc0d3ae76e4";
          sha256 = "sha256-p7ZG4NC9UWa55tPxYAaFocc0waIaTt+WO6MNearbO0U=";
        };
      }
    ];

    initExtraBeforeCompInit = ''
      source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh 2>/dev/null

      fpath=( ${config.xdg.configHome}/zsh/functions "''${fpath[@]}" )
      autoload -Uz $fpath[1]/*
    '';

    initExtra = ''
      source ${config.home.homeDirectory}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      function take() {
        mkdir -p $1
        cd $1
      }

      bindkey \^U backward-kill-line

      export PATH=~/.local/bin:$PATH

      if [[ -f ~/.zshrc.local ]]; then
        source ~/.zshrc.local
      fi

      GLOBALIAS_FILTER_VALUES=(ls)
    '';
  };
}
