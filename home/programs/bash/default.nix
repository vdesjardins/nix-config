{ ... }:
{
  programs.bash = {
    enable = true;

    historyControl = [
      "erasedups"
      "ignoredups"
      "ignorespace"
    ];

    bashrcExtra = ''
      if [ "$(uname)" = "Linux" ]; then
        # for settings specific to one system
        [[ -f ~/.local.env ]] && source ~/.local.env
        [[ -f ~/.local.config ]] && source ~/.local.config
        [[ -f ~/.local.aliases ]] && source ~/.local.aliases
      fi

      # add platform specific bashrc
      if [ -f $HOME/.bashrc-$(uname) ]; then
        . $HOME/.bashrc-$(uname)
      fi

      # Add host/domain specific bashrc
      if [ -f $HOME/.bashrc-$(uname)-$HOST ]; then
        . $HOME/.bashrc-$(uname)-$HOST
      fi

      if [ -f $HOME/.bashrc-$(uname)-$(hostname) ]; then
        . $HOME/.bashrc-$(uname)-$(hostname)
      fi

      set -o emacs
    '';
  };
}
