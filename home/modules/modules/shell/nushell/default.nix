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
        Expandable aliases added to Nushell's fish-style abbreviations.
        These expand inline when you press space or enter.

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
                    def take [dir: path] {
                      mkdir $dir
                      cd $dir
                    }

                    # Fish-style abbreviations expand on space or enter.
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

                    let abbreviations = {
          ${globalAliasesRecord}
                    } | merge ''$kubectl_abbrs

                    $env.config = (
                      $env.config
                      | upsert keybindings [
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
                      | upsert abbreviations $abbreviations
                    )
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
