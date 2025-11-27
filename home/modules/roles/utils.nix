{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.utils;
in {
  options.roles.utils = {
    enable = mkEnableOption "utils";
  };

  config = mkIf cfg.enable {
    programs = {
      broot.enable = true;
      zoxide.enable = true;
    };

    modules.shell = {
      bash.enable = true;
      zsh.enable = true;
      nushell.enable = true;

      tools = {
        btop.enable = true;
        nix.enable = true;
        any-nix-shell.enable = true;
        bat.enable = true;
        direnv.enable = true;
        fd.enable = true;
        gh.enable = true;
        git.enable = true;
        mergiraf.enable = true;
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
        fzf.enable = true;
        tmux.enable = true;
        try.enable = true;
      };
    };

    modules.desktop = {
      terminal = {
        alacritty.enable = true;
        ghostty.enable = true;
        ghostty.useTmux = true;
      };

      editors.nixvim = {
        enable = true;
      };
    };

    home.packages = with pkgs;
      [
        fq # jq for binary formats
        ast-grep # find code by syntax
        bandwhich # network utilization by process
        bottom # top with graphs
        cachix
        circumflex # hackernews reader
        cloc # source code line counter
        coreutils
        curl
        deploy-rs
        dust # fancy du
        duf # df alternative
        file
        findutils
        gdu # interactive du
        glances # glances an eye on your system
        glow # renders markdown on command line
        gnumake
        gnused
        # graphviz
        hexyl # hex viewer
        htop # fancy top
        httpie
        httpx
        hyperfine
        jc # format converter/parser
        jp # jmespath
        jq
        lsof
        meld
        neofetch # fetch system/theme information
        nix-update
        oha # HTTP load generator inspired by rakyll/hey with tui animation
        openssh
        ps
        qrencode
        rsync
        sd # sed replacement
        sslscan
        tealdeer # faster tldr
        pay-respects
        tokei # displays code statistics
        tree
        procs # replacement for ps
        step-cli # plumbing for distributed systems
        wget
        xh # tool to send http request
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
  };
}
