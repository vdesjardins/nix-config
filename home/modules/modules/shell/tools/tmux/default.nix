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
    programs = {
      tmux = {
        inherit (cfg) enable terminal;

        inherit (cfg) prefix;
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
              set -g @fingers-pattern-0 'sha(256|512)-[a-zA-Z0-9+/]+=+'
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

      nushell = {
        shellAliases = {t = "tmux attach -d";};
        extraConfig = ''
          # Refresh SSH_AUTH_SOCK and DISPLAY variables from tmux environment
          def tmux-refresh-env [] {
            if ($env.TMUX? != null) {
              let tmux_env = (tmux show-environment | lines)

              # Update SSH_AUTH_SOCK
              let ssh_auth = ($tmux_env | where ($it | str starts-with "SSH_AUTH_SOCK=") | first)
              if ($ssh_auth != null) {
                $env.SSH_AUTH_SOCK = ($ssh_auth | split row "=" | last)
              }

              # Update DISPLAY
              let display = ($tmux_env | where ($it | str starts-with "DISPLAY=") | first)
              if ($display != null) {
                $env.DISPLAY = ($display | split row "=" | last)
              }
            }
          }

          # Switch to tmux pane by PID
          def tmux-switch-pane-from-pid [proc_pid: int] {
            let pid_tty = (ps | where pid == $proc_pid | get tty | first)
            let pane_info = (tmux list-panes -a -F '#{session_name}:#{window_index}:#{pane_index}:#{pane_tty}'
              | lines
              | where ($it | str contains $pid_tty)
              | first
              | split row ":")

            let session = ($pane_info | first)
            let window_index = ($pane_info | get 1)
            let pane_index = ($pane_info | get 2)

            tmux switch -t $"($session):($window_index).($pane_index)"
          }

          # Switch to tmux pane by file path
          def tmux-switch-pane-from-file [filepath: path] {
            let fname = ($filepath | path expand)
            let proc_pid = (lsof -t $fname | into int)

            if ($proc_pid == null) {
              error make {msg: $"lsof cannot find file ($fname)"}
            }

            tmux-switch-pane-from-pid $proc_pid
          }
        '';
      };

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
