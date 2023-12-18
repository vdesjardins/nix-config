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
    ../../programs/zellij
    ../../programs/zoxide
    ../../programs/zsh
  ];

  home.packages = with pkgs;
    [
      unstable.fq # jq for binary formats
      act # github actions testing
      age # encryption
      age-plugin-yubikey
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
      minisign
      neofetch # fetch system/theme information
      oha # HTTP load generator inspired by rakyll/hey with tui animation
      openssh
      passage # passwords management with age
      ps
      pueue # task management tool
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
      yubikey-manager
      (pkgs.writeScriptBin "json2nix" ''
        ${pkgs.python3}/bin/python ${pkgs.fetchurl {
          url = "https://gist.githubusercontent.com/Scoder12/0538252ed4b82d65e59115075369d34d/raw/e86d1d64d1373a497118beb1259dab149cea951d/json2nix.py";
          hash = "sha256-ROUIrOrY9Mp1F3m+bVaT+m8ASh2Bgz8VrPyyrQf9UNQ=";
        }} $@
      '')
    ]
    ++ lib.optionals stdenv.isLinux [
      iotop
      lshw # list hardware
      psmisc
      sysstat
    ]
    ++ lib.optionals stdenv.isDarwin [
      m-cli # controls apps from command line
    ];
}
