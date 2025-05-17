{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.shell.tools.fzf;
in {
  options.modules.shell.tools.fzf = {
    enable = mkEnableOption "fzf";
    color-scheme = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [fd bat kitty.kitten];

    programs.fzf = {
      enable = true;

      defaultCommand = "fd --type f";
      defaultOptions = ["--height 60%" "--border"];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'bat --color=always {}'"];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
      historyWidgetOptions = ["--layout=reverse" "--sort" "--exact" "--height=60%" "--preview='echo {..}'" "--preview-window='bottom:3:wrap'"];

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

      initContent = ''
        # disable sort when completing `git checkout`
        zstyle ':completion:*:git-checkout:*' sort false
        # set descriptions format to enable group support
        zstyle ':completion:*:descriptions' format '[%d]'
        # set list-colors to enable filename colorizing
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        # preview directory's content with lsd when completing cd
        zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.lsd}/bin/lsd  --color=always --oneline --icon=always $realpath'
        zstyle ':fzf-tab:complete:cp:*' fzf-preview '${pkgs.lsd}/bin/lsd  --color=always --oneline --icon=always --blocks name,date $realpath'
        zstyle ':fzf-tab:complete:mv:*' fzf-preview '${pkgs.lsd}/bin/lsd  --color=always --oneline --icon=always --blocks name,date $realpath'
        # switch group using `,` and `.`
        zstyle ':fzf-tab:*' switch-group '<' '>'

        # complete manual by their section
        zstyle ':completion:*:manuals'   separate-sections true
        zstyle ':completion:*:manuals.*' insert-sections   true
        zstyle ':completion:*:man:*'     menu yes select
      '';
    };

    xdg.configFile."zsh/fzf-colors.zsh".source = cfg.color-scheme;
  };
}
