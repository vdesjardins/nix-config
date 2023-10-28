{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  home.packages = with pkgs; [fd bat];

  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f";
    defaultOptions = ["--height 40%" "--border"];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = ["--preview 'bat --color=always {}'"];
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
    historyWidgetOptions = ["--sort" "--exact"];

    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = ["-u 40%"];
    };

    enableZshIntegration = true;
  };

  programs.zsh = {
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
          sha256 = "sha256-gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
        };
      }
    ];

    envExtra = ''
      source $HOME/.config/zsh/fzf-colors.zsh
    '';

    initExtra = ''
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # preview directory's content with exa when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'

      # complete manual by their section
      zstyle ':completion:*:manuals'   separate-sections true
      zstyle ':completion:*:manuals.*' insert-sections   true
      zstyle ':completion:*:man:*'     menu yes select
    '';
  };

  xdg.configFile."zsh/fzf-colors.zsh".source =
    mkIf config.programs.zsh.enable
    "${pkgs.base16-fzf}/share/base16-fzf/bash/base16-nord.config";
}
