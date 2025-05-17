{
  config,
  pkgs,
  lib,
  stdenv,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.tmux;
in {
  options.modules.shell.tools.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ncurses];

    programs = {
      tmux = {
        inherit (cfg) enable;

        prefix = "C-_";
        baseIndex = 1;
        clock24 = true;
        historyLimit = 100000;
        escapeTime = 0;
        keyMode = "vi";
        shell = "${pkgs.zsh}/bin/zsh";

        extraConfig = pkgs.callPackage ./tmux.nix {};

        plugins = with pkgs.tmuxPlugins; [
          # [theme]
          tokyo-night
          tmux-fzf
          tmux-thumbs
        ];

        tmuxp.enable = true;
      };

      zsh.shellAliases = {t = "tmux attach -d";};

      zsh.initContent = ''
        preexec_functions+=(__tmux-refresh-env-preexec)
      '';
    };

    xdg.configFile = {
      "zsh/functions/__tmux-refresh-env-preexec".source =
        ./zsh/functions/__tmux-refresh-env-preexec;
      "zsh/functions/tmux-switch-pane-from-file".source =
        ./zsh/functions/tmux-switch-pane-from-file;
      "zsh/functions/tmux-switch-pane-from-pid".source =
        ./zsh/functions/tmux-switch-pane-from-pid;
    };
  };
}
