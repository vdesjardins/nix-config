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
      comma
      ctags
      curl
      du-dust # fancy du
      fd # fast file search
      findutils
      glow # renders markdown on command line
      gnumake
      gnused
      grpcurl
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
      openssh
      tealdeer # faster tldr
      tokei # displays code statistics
      topgrade # keep system up to date
      tree
      wrk # http benchmarking tool
    ] ++ lib.optionals stdenv.isLinux [
      pueue # task management tool
      sysstat
      thefuck # fix commands
      wget
    ] ++ lib.optionals stdenv.isDarwin [
      m-cli # controls apps from command line
      xquartz # X.Org Window System
    ];
}
