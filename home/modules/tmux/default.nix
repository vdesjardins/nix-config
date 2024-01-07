{
  config,
  pkgs,
  lib,
  stdenv,
  ...
}:
with lib; {
  config = mkIf config.programs.tmux.enable {
    home.packages = with pkgs; [ncurses];

    programs.tmux = {
      prefix = "`";
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

    programs.zsh.shellAliases = {t = "tmux attach -d";};

    programs.zsh.initExtra = ''
      preexec_functions+=(__tmux-refresh-env-preexec)
    '';

    xdg.configFile."zsh/functions/__tmux-refresh-env-preexec".source =
      ./zsh/functions/__tmux-refresh-env-preexec;
    xdg.configFile."zsh/functions/tmux-switch-pane-from-file".source =
      ./zsh/functions/tmux-switch-pane-from-file;
    xdg.configFile."zsh/functions/tmux-switch-pane-from-pid".source =
      ./zsh/functions/tmux-switch-pane-from-pid;
  };
}