{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str attrsOf;

  cfg = config.modules.shell.tools.git;
in {
  options.modules.shell.tools.git = {
    enable = mkEnableOption "git scm";

    delta = mkOption {
      type = attrsOf str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.gitAndTools; [
      commitizen
      gita
      git-absorb
      # git-revise
      delta
      git-filter-repo
      git-extras
      git-recent
      lab
      pre-commit
      tig
      gitui
    ];

    programs = {
      git = {
        inherit (cfg) enable;

        userEmail = "vdesjardins@gmail.com";
        userName = "Vincent Desjardins";

        package = pkgs.git;

        lfs = {
          enable = true;
        };

        delta = {
          enable = true;
          options =
            {
              decorations = {
                commit-decoration-style = "bold yellow box ul";
                file-decoration-style = "none";
                file-style = "bold yellow ul";
              };
              features = "line-numbers decorations diff-so-fancy";
              whitespace-error-style = "22 reverse";
            }
            // cfg.delta;
        };

        ignores = [".DS_Store"];

        includes = [{path = "~/.gitconfig.local";}];

        extraConfig = {
          help = {autocorrect = true;};

          column = {
            ui = "auto";
          };

          grep = {
            perlRegexp = true;
          };

          rerere = {
            enabled = true;
            autoupdate = true;
          };

          commit = {
            verbose = true;
          };

          merge = {
            conflictstyle = "diff3";
            tool = "vimdiff";
            renamelimit = 3000;
          };

          diff = {
            renameLimit = 3000;
            algorithm = "histogram";
            colorMoved = "plain";
            mnemonicPrefix = true;
            context = 5;
            renames = "true";

            dyff = {
              command = "dyff_between() { ${pkgs.dyff}/bin/dyff --color on between \"$2\" \"$5\"; }; dyff_between";
            };
          };

          push = {
            default = "simple";
            followTags = true;
            autoSetupRemote = true;
          };

          pull = {rebase = true;};

          fetch = {
            prune = true;
            pruneTags = true;
            all = true;
          };

          branch = {
            autosetuprebase = "always";
            sort = "-commiterdate";
          };

          tag = {
            sort = "version:refname";
          };

          rebase = {
            rebase = true;
            autoStash = true;
            updateRefs = true;
            autoSquash = true;
          };

          github = {user = "vdesjardins";};

          init = {defaultBranch = "main";};

          color = {
            diff = {
              meta = "yellow bold";
              frag = "magenta bold";
              old = "red bold";
              new = "green bold";
              whitespace = "red reverse";
            };
            status = {
              added = "yellow";
              changed = "green";
              untracked = "cyan";
            };
            branch = {
              current = "yellow reverse";
              local = "yellow";
              remote = "green";
            };
            ui = "auto";
            interactive = "auto";
          };
        };

        aliases = let
          lg = "log --graph --pretty=format:'%Cred%h%Creset %G? -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        in {
          st = "status";
          c = "commit -s";
          ca = "commit --amend";
          cm = "commit -s -m";
          cf = "commit --fixup";
          re = "restore";
          sw = "switch";
          swc = "switch -c";
          ps = "push";
          psf = "push --force-with-lease";
          pl = "pull --rebase";
          br = "branch";
          bra = "branch -a";
          brd = "branch -d";
          brdf = "branch -D";
          bi = "bisect";
          a = "add";
          d = "diff";
          dc = "diff --cached";
          dm = "diff master";
          f = "fetch";
          l = "log --numstat";
          mt = "mergetool";
          who = "shortlog -s --";
          r = "rebase";
          ri = "rebase -i";
          res = "restore --staged";
          remove = "!sh -c 'git ls-files --deleted -z | xargs -0 git rm'";
          untracked = "ls-files --others --exclude-standard";
          whois = ''
            !sh -c 'git log -i -1 --pretty="format:%an <%ae>
            " --author="$1"' -'';
          whatis = "show -s --pretty='tformat:%h (%s, %ad)' --date=short";
          intercommit = ''
            !sh -c 'git show "$1" > .git/commit1 && git show "$2" > .git/commit2 && interdiff .git/commit[12] | less -FRS' -'';
          edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
          add-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`";

          graphviz = ''
            !f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' "$@" | sed 's/[0-9a-f][0-9a-f]*/"&"/g' ; echo '}'; }; f'';

          alias = ''
            !sh -c '[ $# = 2 ] && git config --global alias."$1" "$2" && exit 0 || echo "usage: git alias <new alias> <original command>" >&2 && exit 1' -'';
          aliases = "!git config --get-regexp 'alias.*' | colrm 1 6 | sed 's/[ ]/ = /'";

          inherit lg;
          lgm = ''!sh -c "git ${lg} --author=`git config user.email`"'';
          sl = ''log --pretty=format:"%h%x09%an%x09%ad%x09%s" --date=short'';

          t = "tag -s";
          tl = "tag";
          ta = "tag -s -a";
          tls = "for-each-ref --format='%(refname:short) %(taggerdate) %(subject)' refs/tags";

          sli = "stash list --format='%gd (%cr): %gs'";

          nah = ''!f(){ git reset --hard; git clean -df; if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]; then git rebase --abort; fi; }; f'';

          change-commits = ''!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter "if [[ \"$`echo $VAR`\" = '$OLD' ]]; then export $VAR='$NEW'; fi" \$@; }; f'';
        };
      };

      zsh.shellAliases = {
        g = "git";
        gr = "cd $(git rev-parse --show-toplevel)";
        gow = ''fd -H '^\.git$' ~/projects/ | sed -e 's/\.git\/$//g' | fzf | xargs -L1 bash -c 'cd "$0" && git config remote.origin.url' | sed -re 's,^git@(.*):(.*)(\.git)?$,https://\1/\2,' | xargs open'';
      };

      zsh.shellGlobalAliases = {
        GR = "$(git rev-parse --show-toplevel)";
      };
    };
  };
}
