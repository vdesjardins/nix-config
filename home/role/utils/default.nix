{ pkgs, ... }: {
  imports = [
    ../../program/neovim
    ../../program/bash
    ../../program/zsh
    ../../program/starship
    ../../program/git
    ../../program/tmux
    ../../program/gh
    ../../program/zoxide
    ../../program/fzf
    ../../program/just
    ../../program/openssl
    ../../program/bat
    ../../program/exa
    ../../program/broot
    ../../program/direnv
    ../../program/any-nix-shell
    ../../program/ls
  ];

  home.packages = with pkgs;
    [
      act # github actions testing
      bandwhich # network utilization by process
      coreutils
      bottom # top with graphs
      browsh # terminal browser
      cachix
      cloc # source code line counter
      cmake
      ctags
      curl
      du-dust # fancy du
      duf # df alternative
      fd # fast file search
      findutils
      # unstable.fq # jq for binary formats
      glow # renders markdown on command line
      gnumake
      gnused
      graphviz
      grpcurl
      htmlq # Like jq, but for HTML
      htop # fancy top
      hexyl
      hyperfine
      iotop
      jq
      lazygit
      lorri # nix-shell replacement
      lsof
      ps
      ripgrep
      rsync
      spotify-tui
      openssh
      tealdeer # faster tldr
      tokei # displays code statistics
      tree
      perlPackages.vidir # edit files in EDITOR
    ] ++ lib.optionals stdenv.isLinux [
      unstable.btop # monitor resources
      pueue # task management tool
      sysstat
      thefuck # fix commands
      wget
    ] ++ lib.optionals stdenv.isDarwin [
      m-cli # controls apps from command line
    ];
}
