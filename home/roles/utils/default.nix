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
    ../../programs/neovim
    ../../programs/openssl
    ../../programs/ripgrep
    ../../programs/sapling
    ../../programs/starship
    ../../programs/tmux
    ../../programs/zellij
    ../../programs/zoxide
    ../../programs/zsh
  ];

  home.packages = with pkgs;
    [
      unstable.fq # jq for binary formats
      act # github actions testing
      age # encryption
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
      minisign
      neofetch
      oha # HTTP load generator inspired by rakyll/hey with tui animation
      openssh
      passage # passwords management with age
      ps
      rsync
      spotify-tui
      tealdeer # faster tldr
      tokei # displays code statistics
      tree
      ultralist
      unstable.procs # replacement for ps
      yq
      yubikey-manager
    ]
    ++ lib.optionals stdenv.isLinux [
      unstable.btop # monitor resources
      iotop
      lshw # list hardware
      pueue # task management tool
      psmisc
      screenfetch # fetch system/theme information
      sysstat
      thefuck # fix commands
      wget
    ]
    ++ lib.optionals stdenv.isDarwin [
      m-cli # controls apps from command line
    ];
}
