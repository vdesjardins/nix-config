{pkgs, ...}: {
  imports = [
    ../../programs/any-nix-shell
    ../../programs/bash
    ../../programs/bat
    ../../programs/broot
    ../../programs/direnv
    ../../programs/fd
    ../../programs/fzf
    ../../programs/gh
    ../../programs/git
    ../../programs/lazygit
    ../../programs/joshuto
    ../../programs/just
    ../../programs/ls
    ../../programs/lsd
    ../../programs/ncspot
    ../../programs/neovim
    ../../programs/openssl
    ../../programs/ripgrep
    ../../programs/starship
    ../../programs/tmux
    ../../programs/yazi
    ../../programs/zellij
    ../../programs/zoxide
    ../../programs/zsh
  ];

  home.packages = with pkgs;
    [
      unstable.fq # jq for binary formats
      act # github actions testing
      ast-grep # find code by syntax
      bandwhich # network utilization by process
      bottom # top with graphs
      browsh # terminal browser
      cachix
      cloc # source code line counter
      cmake
      coreutils
      ctags
      curl
      dasel
      du-dust # fancy du
      duf # df alternative
      file
      findutils
      glances # glances an eye on your system
      glow # renders markdown on command line
      gnumake
      gnused
      # graphviz
      grpcurl
      hexyl # hex viewer
      htmlq # Like jq, but for HTML
      htop # fancy top
      httpie
      hyperfine
      jc # json conversion
      jp # jmespath
      jq
      jrnl
      lsof
      neofetch # fetch system/theme information
      oha # HTTP load generator inspired by rakyll/hey with tui animation
      openssh
      ps
      pueue # task management tool
      qrencode
      rsync
      spotify-tui
      taskwarrior
      taskwarrior-tui
      timewarrior
      tealdeer # faster tldr
      thefuck # fix commands
      tokei # displays code statistics
      tree
      unstable.btop # monitor resources
      unstable.procs # replacement for ps
      wget
      yq
    ]
    ++ lib.optionals stdenv.isLinux [
      iotop
      lshw # list hardware
      psmisc
      sysstat
      ueberzugpp
    ]
    ++ lib.optionals stdenv.isDarwin [
      m-cli # controls apps from command line
    ];
}
