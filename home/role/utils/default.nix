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
      # unstable.fq # jq for binary formats
      act # github actions testing
      bandwhich # network utilization by process
      bottom # top with graphs
      browsh # terminal browser
      cachix
      cloc # source code line counter
      cmake
      coreutils
      ctags
      curl
      du-dust # fancy du
      duf # df alternative
      fd # fast file search
      findutils
      glow # renders markdown on command line
      gnumake
      gnused
      graphviz
      grpcurl
      hexyl
      htmlq # Like jq, but for HTML
      htop # fancy top
      hyperfine
      iotop
      jq
      lazygit
      lsof
      oha # HTTP load generator inspired by rakyll/hey with tui animation
      openssh
      perlPackages.vidir # edit files in EDITOR
      ps
      ripgrep
      rsync
      spotify-tui
      tealdeer # faster tldr
      tokei # displays code statistics
      tree
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
