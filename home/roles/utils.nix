{pkgs, ...}: {
  programs.alacritty.enable = true;
  programs.wezterm.enable = true;
  programs.any-nix-shell.enable = true;
  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.direnv.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.gh.enable = true;
  programs.git.enable = true;
  programs.lazygit.enable = true;
  programs.joshuto.enable = true;
  programs.ls.enable = true;
  programs.lsd.enable = true;
  programs.ncspot.enable = true;
  programs.openssl.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.tmux.enable = true;
  programs.yazi.enable = true;
  programs.zellij.enable = true;
  programs.zoxide.enable = true;
  programs.zsh.enable = true;
  programs.timewarrior.enable = true;

  programs.nvim = {
    enable = true;
    package = pkgs.neovim-nightly;
  };

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
      just
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
