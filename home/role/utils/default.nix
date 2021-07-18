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
      act
      #bandwhich
      coreutils
      #bottom
      cachix
      comma
      ctags
      curl
      fd
      findutils
      glow
      gnumake
      gnused
      grpcurl
      htop
      hexyl
      hyperfine
      #iotop
      jq
      lazygit
      lsof
      ps
      ripgrep
      rsync
      openssh
      tokei
      topgrade
      tree
      wrk
    ] ++ (if !stdenv.isDarwin then [ pueue sysstat wget ] else [ ]);
}
