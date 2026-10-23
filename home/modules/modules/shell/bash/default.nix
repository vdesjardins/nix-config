{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.bash;
in {
  options.modules.shell.bash = {
    enable = mkEnableOption "bash";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      inherit (cfg) enable;

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
      '';
    };

    # Non-interactive Bash returns from Home Manager's generated ~/.bashrc
    # before reaching its alias declarations. Emit an alias-only file for
    # consumers such as Pi's !/!! commands.
    home.file.".bash_aliases".text =
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: value: "alias -- ${lib.escapeShellArg name}=${lib.escapeShellArg value}"
        )
        config.programs.bash.shellAliases
      )
      + "\n";
  };
}
