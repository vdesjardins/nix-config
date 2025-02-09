{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.nushell;
in {
  options.modules.shell.nushell = {
    enable = mkEnableOption "nushell";
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      inherit (cfg) enable;

      settings = {
        show_banner = false;
      };

      extraConfig =
        # nu
        ''
          def history_search [] {
            commandline edit ( history | each { |it| $it.command }
              | uniq
              | reverse
              | str join (char -i 0)
              | fzf --read0 --layout=reverse --height=60% --preview='echo {..}' --preview-window='bottom:3:wrap' --bind='alt-up:preview-up,alt-down:preview-down' -q (commandline)
              | decode utf-8
              | str trim)
          }

          $env.config = {
            keybindings: [{
              name: fuzzy_history
              modifier: control
              keycode: char_r
              mode: [emacs, vi_normal, vi_insert]
              event: [
              {
                send: ExecuteHostCommand
                cmd: "history_search"
              }
              ]
            }]
          }
        '';

      shellAliases = {
        "lltr" = "ls | sort-by modified";
        "ll" = "ls";
        "lla" = "ls --all";
      };
    };
  };
}
