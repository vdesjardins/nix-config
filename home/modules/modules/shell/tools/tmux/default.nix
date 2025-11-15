{
  config,
  pkgs,
  my-packages,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.tmux;
in {
  options.modules.shell.tools.tmux = {
    enable = mkEnableOption "tmux";

    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-Space";
      description = "The tmux prefix key.";
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "ghostty";
      description = "The terminal emulator to use.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ncurses];

    programs = {
      tmux = {
        inherit (cfg) enable terminal;

        prefix = cfg.prefix;
        baseIndex = 1;
        clock24 = true;
        historyLimit = 100000;
        escapeTime = 0;
        keyMode = "vi";
        shell = "${pkgs.zsh}/bin/zsh";

        extraConfig = pkgs.callPackage ./tmux.nix {inherit my-packages;};

        plugins = with pkgs.tmuxPlugins; [
          tmux-fzf
          {
            plugin = fingers;
            extraConfig = ''
              set -g @fingers-key Space
              set -g @fingers-hint-style 'fg=red,bold,underscore'
            '';
          }

          {
            # [theme]
            plugin = tokyo-night-tmux;
            extraConfig = ''
              set -g @tokyo-night-tmux_theme 'storm'
            '';
          }
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
