{ config, lib, pkgs, ... }:

with lib;

{
  home.packages = with pkgs; [ fd bat ];

  programs.fzf = {
    enable = true;

    enableZshIntegration = true;
  };

  programs.zsh = {
    envExtra = ''
      source $HOME/.config/zsh/fzf-colors.zsh
      export FZF_CTRL_T_OPTS="--bind 'ctrl-p:toggle-preview,ctrl-e:execute-silent(nvim {})+abort' --preview-window=right:60% --preview '${pkgs.bat}/bin/bat --color=always {} 2>/dev/null'"
      export FZF_DEFAULT_COMMAND='${pkgs.fd}/bin/fd --type f'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    '';
  };

  xdg.configFile."zsh/fzf-colors.zsh".source = mkIf config.programs.zsh.enable
    "${pkgs.base16-fzf}/share/base16-fzf/bash/base16-snazzy.config";
}
