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
        Shell aliases added to Nushell.

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
      globalAliasesRecord = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: value: "          ${builtins.toJSON name}: ${builtins.toJSON value}")
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
                    def mkcd [dir: path] {
                      mkdir $dir
                      cd $dir
                    }

                    let abbreviations = {
          ${globalAliasesRecord}
                    }

                    def __expand_abbreviation [accept: bool] {
                      let line = (commandline)
                      let words = ($line | split row " " | where {|it| $it != "" })

                      if ($words | is-empty) {
                        if $accept {
                          commandline edit --accept $line
                        } else {
                          commandline edit --insert " "
                        }
                      } else {
                        let last = ($words | last)
                        let has_abbreviation = not (($abbreviations | columns | where {|it| $it == $last} | is-empty))

                        if $has_abbreviation {
                          let prefix_count = (($words | length) - 1)
                          let prefix = ($words | first $prefix_count | str join " ")
                          let replacement = ($abbreviations | get $last)
                          let new_line = if ($prefix | is-empty) {
                            $replacement
                          } else {
                            $"($prefix) ($replacement)"
                          }

                          if $accept {
                            commandline edit --replace --accept $new_line
                          } else {
                            commandline edit --replace $"($new_line) "
                          }
                        } else if $accept {
                          commandline edit --accept $line
                        } else {
                          commandline edit --insert " "
                        }
                      }
                    }

                    let keybindings = [
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

                    let keybindings = ($keybindings | append {
                      name: expand_abbreviation_space
                      modifier: none
                      keycode: space
                      mode: [emacs, vi_insert]
                      event: [
                        {
                          send: ExecuteHostCommand
                          cmd: "__expand_abbreviation false"
                        }
                      ]
                    } | append {
                      name: expand_abbreviation_enter
                      modifier: none
                      keycode: enter
                      mode: [emacs, vi_insert]
                      event: [
                        {
                          send: ExecuteHostCommand
                          cmd: "__expand_abbreviation true"
                        }
                      ]
                    })

                    $env.config = (
                      $env.config
                      | upsert keybindings $keybindings
                      | upsert cursor_shape {
                          vi_insert: line
                          vi_normal: block
                          emacs: line
                        }
                      | upsert completions {
                          external: {
                            enable: true
                            completer: $external_completer
                          }
                        }
                    )
        '';

      shellAliases =
        {
          cat = "bat";
          ll = "ls";
          lla = "ls --all";
        }
        // cfg.globalAliases;

      environmentVariables = {
        CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense";
      };
    };
  };
}
