{
  pkgs,
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
    home.packages = with pkgs; [carapace fish];

    programs.nushell = {
      inherit (cfg) enable;

      settings = {
        show_banner = false;
      };

      extraConfig =
        # nu
        ''
          let fish_completer = {|spans|
              fish --command $'complete "--do-complete=($spans | str join " ")"'
              | from tsv --flexible --noheaders --no-infer
              | rename value description
          }

          let zoxide_completer = {|spans|
              $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
          }

          let carapace_completer = {|spans: list<string>|
              carapace $spans.0 nushell ...$spans
              | from json
              | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
          }

          # This completer will use carapace by default
          let external_completer = {|spans|
              let expanded_alias = scope aliases
              | where name == $spans.0
              | get -i 0.expansion

              let spans = if $expanded_alias != null {
                  $spans
                  | skip 1
                  | prepend ($expanded_alias | split row ' ' | take 1)
              } else {
                  $spans
              }

              match $spans.0 {
                  # carapace completions are incorrect for nu
                  # nu => $fish_completer
                  # fish completes commits and branch names in a nicer way
                  # git => $fish_completer
                  # use zoxide completions for zoxide commands
                  __zoxide_z | __zoxide_zi => $zoxide_completer
                  _ => $fish_completer
              } | do $in $spans
          }

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

            completions: {
              external: {
                enable: true
                completer: $external_completer
              }
            }
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
