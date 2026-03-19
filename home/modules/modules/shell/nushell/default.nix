{
  pkgs,
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.nushell;
in {
  options.modules.shell.nushell = {
    enable = mkEnableOption "nushell";

    globalAliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = ''
        Expandable aliases that will be added to nushell's abbreviations dictionary.
        These aliases expand inline when you press space or enter.

        Example:
          modules.shell.nushell.globalAliases = {
            kgp = "kubectl get pods";
            gst = "git status";
          };
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [carapace];

    programs.nushell = let
      # Build abbreviations from globalAliases
      globalAliasesStr = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "            ${name}: \"${value}\"")
        cfg.globalAliases
      );
    in {
      inherit (cfg) enable;

      settings = {
        show_banner = false;
      };

      extraConfig =
        # nu
        ''
                    let zoxide_completer = {|spans|
                        $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
                    }

                    let carapace_completer = {|spans|
                        load-env {
                            CARAPACE_SHELL_BUILTINS: (help commands | where category != "" | get name | each { split row " " | first } | uniq | str join "\n")
                            CARAPACE_SHELL_FUNCTIONS: (help commands | where category == "" | get name | each { split row " " | first } | uniq | str join "\n")
                        }
                        let expanded_alias = (scope aliases | where name == $spans.0 | $in.0?.expansion?)
                        let spans = (if $expanded_alias != null {
                            $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
                        } else {
                            $spans | skip 1 | prepend ($spans.0)
                        })
                        carapace $spans.0 nushell ...$spans
                        | from json
                    }

                    # Route to the appropriate completer based on command
                    let external_completer = {|spans|
                        match $spans.0 {
                            __zoxide_z | __zoxide_zi => $zoxide_completer
                            _ => $carapace_completer
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
                    # Load all defined aliases from scope and merge with custom abbreviations
                    let kubectl_aliases_file = "${my-packages.kubectl-aliases}/share/kubectl-aliases/kubectl_aliases.nu"
                    let kubectl_abbrs = if (''$kubectl_aliases_file | path exists) {
                      open ''$kubectl_aliases_file
                        | lines
                        | where (''$it | str starts-with "alias ")
                        | each { |line|
                            let parts = (''$line | str replace "alias " "" | split row " = ")
                            if (''$parts | length) == 2 {
                              {key: (''$parts.0 | str trim), value: (''$parts.1 | str trim)}
                            }
                          }
                        | where (''$it | is-not-empty)
                        | reduce -f {} { |it, acc| ''$acc | merge {(''$it.key): (''$it.value)} }
                    } else {
                      {}
                    }

                    let abbreviations = ''$kubectl_abbrs | merge {
          ${globalAliasesStr}
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
                        {
                          name: insert_last_token
                          modifier: alt
                          keycode: char_.
                          mode: emacs
                          event: [
                            { edit: InsertString, value: "!$" }
                            { send: Enter }
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
        cat = "bat";
        ll = "ls";
        lla = "ls --all";
      };

      environmentVariables = {
        CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
      };
    }; # end programs.nushell let binding
  };
}
