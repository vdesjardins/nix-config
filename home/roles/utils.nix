{
  config,
  pkgs,
  ...
}: {
  programs = {
    broot.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
  };

  modules.shell = {
    bash.enable = true;
    zsh.enable = true;

    tools = {
      nix.enable = true;
      any-nix-shell.enable = true;
      bat.enable = true;
      direnv.enable = true;
      fd.enable = true;
      gh.enable = true;
      git.enable = true;
      joshuto.enable = true;
      jujutsu.enable = true;
      lazygit.enable = true;
      ls.enable = true;
      lsd.enable = true;
      nix-index.enable = true;
      openssl.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      timewarrior.enable = true;
      yazi.enable = true;
    };
  };

  modules.desktop = {
    terminal.wezterm.enable = true;
    terminal.alacritty.enable = true;
    terminal.ghostty.enable = true;
    editors.neovim = {
      package = pkgs.neovim-unwrapped;
      enable = true;
    };
  };

  home.packages = with pkgs;
    [
      fq # jq for binary formats
      act # github actions testing
      ast-grep # find code by syntax
      bandwhich # network utilization by process
      bottom # top with graphs
      browsh # terminal browser
      cachix
      circumflex # hackernews reader
      cloc # source code line counter
      cmake
      coreutils
      ctags
      curl
      dasel
      deploy-rs
      du-dust # fancy du
      duf # df alternative
      figlet # generate large text
      file
      findutils
      gdu # interactive du
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
      just
      lsof
      meld
      neofetch # fetch system/theme information
      oha # HTTP load generator inspired by rakyll/hey with tui animation
      openssh
      ps
      pueue # task management tool
      qrencode
      rsync
      sd # sed replacement
      sslscan
      tealdeer # faster tldr
      thefuck # fix commands
      tokei # displays code statistics
      tree
      btop # monitor resources
      procs # replacement for ps
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
      pngpaste
    ];
}
