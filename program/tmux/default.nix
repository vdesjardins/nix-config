{ config, lib, pkgs, ... }:

with lib;

mkMerge [
  {
    programs.tmux = { enable = true; };

    nixpkgs.overlays = [
      (
        self: super: {
          tmux = super.tmux.overrideDerivation (
            attrs: {
              src = pkgs.fetchFromGitHub {
                owner = "tmux";
                repo = "tmux";
                rev = "be568ea3b21b88763d2cc274bdec3a476136de2f";
                sha256 = "0jn7dmqx8gbf3jpf88d8yj5isjplwvcs26z3hdwwywikaq7gp1h5";
              };
            }
          );
        }
      )
    ];

    programs.zsh.shellAliases = { t = "tmux attach -d"; };

    xdg.configFile."tmux/tmux.conf".text = pkgs.callPackage ./tmux.nix {};
    xdg.configFile."tmux/tmux-theme.conf".source = ./tmux-theme.conf;

    programs.neovim.plugins = with pkgs.vimPlugins; [
      vim-tmux-focus-events
      vim-tmux-clipboard
    ];
  }

  (
    mkIf config.programs.zsh.enable {
      programs.zsh.initExtra = ''
        preexec_functions+=(__tmux-refresh-env-preexec)
      '';

      xdg.configFile."zsh/functions/__tmux-refresh-env-preexec".source =
        ./zsh/functions/__tmux-refresh-env-preexec;
      xdg.configFile."zsh/functions/tmux-switch-pane-from-file".source =
        ./zsh/functions/tmux-switch-pane-from-file;
      xdg.configFile."zsh/functions/tmux-switch-pane-from-pid".source =
        ./zsh/functions/tmux-switch-pane-from-pid;
    }
  )
]
