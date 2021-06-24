{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gitAndTools.delta
    gitAndTools.git-filter-repo
    git-revise
  ];

  programs.git = {
    enable = true;
    userEmail = "vdesjardins@gmail.com";
    userName = "Vincent Desjardins";
    signing.key = "04C423B8C964B58C";
    signing.signByDefault = true;

    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "line-numbers decorations diff-so-fancy";
        whitespace-error-style = "22 reverse";
      };
    };

    ignores = [ ".DS_Store" ];

    includes = [ { path = "~/.gitconfig.local"; } ];

    extraConfig = {
      help = { autocorrect = 20; };

      merge = {
        conflictstyle = "diff3";
        tool = "vimdiff";
        renamelimit = 3000;
      };

      diff = {
        renameLimit = 3000;
        algorithm = "patience";
        colorMoved = "default";
      };

      push = {
        default = "current";
        followTags = true;
      };

      pull = { rebase = true; };

      branch = { autosetuprebase = "always"; };

      rebase = {
        rebase = true;
        autoStash = true;
      };

      github = { user = "vdesjardins"; };

      tag = { gpgSign = true; };

      init = { defaultBranch = "main"; };

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

    aliases = {
      st = "status";
      c = "commit";
      ca = "commit --amend";
      cm = "commit -m";
      co = "checkout";
      cob = "checkout -b";
      sw = "switch";
      swc = "switch -c";
      ps = "push";
      psf = "push --force-with-lease";
      pl = "pull --rebase";
      br = "branch";
      bra = "branch -a";
      brd = "branch -d";
      brD = "branch -D";
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
      remove = "!sh -c 'git ls-files --deleted -z | xargs -0 git rm'";
      whois = ''
        !sh -c 'git log -i -1 --pretty="format:%an <%ae>
        " --author="$1"' -'';
      whatis = "show -s --pretty='tformat:%h (%s, %ad)' --date=short";
      intercommit = ''
        !sh -c 'git show "$1" > .git/commit1 && git show "$2" > .git/commit2 && interdiff .git/commit[12] | less -FRS' -'';
      edit-unmerged =
        "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
      add-unmerged =
        "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`";
      graphviz = ''
        !f() { echo 'digraph git {' ; git log --pretty='format:  %h -> { %p }' "$@" | sed 's/[0-9a-f][0-9a-f]*/"&"/g' ; echo '}'; }; f'';
      alias = ''
        !sh -c '[ $# = 2 ] && git config --global alias."$1" "$2" && exit 0 || echo "usage: git alias <new alias> <original command>" >&2 && exit 1' -'';
      aliases =
        "!git config --get-regexp 'alias.*' | colrm 1 6 | sed 's/[ ]/ = /'";
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset %G? -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      sl = ''log --pretty=format:"%h%x09%an%x09%ad%x09%s" --date=short'';
      t = "tag -s";
      tl = "tag";
      ta = "tag -s -a";
      tls =
        "for-each-ref --format='%(refname:short) %(taggerdate) %(subject)' refs/tags";
      sli = "stash list --format='%gd (%cr): %gs'";

      change-commits = ''!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter "if [[ \"$`echo $VAR`\" = '$OLD' ]]; then export $VAR='$NEW'; fi" \$@; }; f'';
    };
  };

  programs.zsh.shellAliases = { g = "git"; };
}
