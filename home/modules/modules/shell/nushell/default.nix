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
              | get -o 0.expansion

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

          # Create directory and cd into it (equivalent to zsh take function)
          def take [dir: path] {
            mkdir $dir
            cd $dir
          }

          # Fish-like abbreviations
          let abbreviations = {
            gst: "git status"
            gco: "git checkout"
            gp: "git push"
            gl: "git pull"
            gd: "git diff"
            ga: "git add"
            gc: "git commit"
            gcm: "git commit -m"
            glog: "git log --oneline --graph"
            k: "kubectl"
            kgp: "kubectl get pods"
            kgs: "kubectl get services"
            kgd: "kubectl get deployments"
            d: "docker"
            dc: "docker-compose"
            tf: "terraform"
            tg: "terragrunt"
            # Global aliases (kubectl)
            SL: "--show-labels"
            OJ: "-ojson"
            OJB: "-ojson |& bat -ljson"
            OY: "-oyaml"
            OK: "-okyaml"
            OYB: "-oyaml |& bat -lyaml"
            OKB: "-okyaml |& bat -lyaml"
            OW: "-owide"
            # Global aliases (git)
            GR: "$(git rev-parse --show-toplevel)"
            # Global aliases (bat)
            BJ: "|& bat -ljson"
            BY: "|& bat -lyaml"
            BT: "|& bat"
          }

          $env.config = {
            keybindings: [
              {
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
              }
              {
                name: abbr_menu
                modifier: none
                keycode: enter
                mode: [emacs, vi_normal, vi_insert]
                event: [
                    { send: menu name: abbr_menu }
                    { send: enter }
                ]
              }
              {
                name: accept_abbr
                modifier: control
                keycode: char_y
                mode: [emacs, vi_normal, vi_insert]
                event: [
                  { send: HistoryHintComplete }]
              }
              {
                name: abbr_menu
                modifier: none
                keycode: space
                mode: [emacs, vi_normal, vi_insert]
                event: [
                    { send: menu name: abbr_menu }
                    { edit: insertchar value: ' '}
                ]
              }
            ]

            cursor_shape: {
              vi_insert: line
              vi_normal: block
              emacs: line
            }

            menus: [
              {
                name: abbr_menu
                only_buffer_difference: false
                marker: none
                type: {
                  layout: columnar
                  columns: 1
                  col_width: 20
                  col_padding: 2
                }
                style: {
                  text: green
                  selected_text: green_reverse
                  description_text: yellow
                }
                source: { |buffer, position|
                  let before_cursor = (''$buffer | str substring 0..''$position)
                  let current_word = (''$before_cursor | split row ' ' | last)

                  let match = ''$abbreviations | columns | where ''$it == ''$current_word
                  if (''$match | is-empty) {
                    { value: ''$buffer }
                  } else {
                    let replacement = (''$abbreviations | get ''$match.0)
                    let word_len = (''$current_word | str length | into int)
                    let before_word_end = (''$position - ''$word_len)
                    let before_word = if ''$before_word_end > 0 {
                      (''$buffer | str substring 0..<''$before_word_end)
                    } else {
                      '''
                    }
                    let after_cursor = (''$buffer | str substring ''$position..)
                    { value: (''$before_word ++ ''$replacement ++ ''$after_cursor) }
                  }
                }
              }
            ]

            completions: {
              external: {
                enable: true
                completer: $external_completer
              }
            }
          }
        '';

      shellAliases = {
        ll = "ls";
        lla = "ls --all";
      };
    };
  };
}
