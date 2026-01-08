{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;

  cfg = config.modules.shell.tools.jujutsu;
in {
  options.modules.shell.tools.jujutsu = {
    enable = mkEnableOption "jujutsu scm";

    email = mkOption {
      type = str;
      default = "vdesjardins@gmail.com";
    };

    username = mkOption {
      type = str;
      default = "Vincent Desjardins";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      difftastic
    ];

    programs = {
      jujutsu = {
        inherit (cfg) enable;

        package = pkgs.jujutsu;

        settings = {
          user = {
            inherit (cfg) email;
            name = cfg.username;
          };

          ui = {
            default-command = "log";
            pager = "delta";
            diff-formatter = ":git";
            merge-editor = "meld";
            diff-editor = ":builtin";
          };

          remotes.origin.auto-track-bookmarks = "glob:*";

          revset-aliases = {
            "user()" = ''user("${cfg.email}")'';
            "user(x)" = "author(x) | committer(x)";
          };

          aliases = {
            a = ["absorb"];
            ab = ["abandon"];
            bc = ["bookmark" "create"];
            bd = ["bookmark" "delete"];
            bl = ["bookmark" "list"];
            bs = ["bookmark" "set"];
            bsm = ["bookmark" "set" "main" "-r" "@-" "--allow-backwards"];
            d = ["diff"];
            de = ["describe"];
            dem = ["describe" "-m"];
            dep = ["describe" "@-"];
            depm = ["describe" "@-" "-m"];
            e = ["edit"];
            en = ["jj" "edit" "@+"];
            ep = ["jj" "edit" "@-"];
            g = ["git"];
            gf = ["git" "fetch"];
            gi = ["git" "init"];
            gp = ["git" "push"];
            gpc = ["git" "push" "-c" "@"];
            lg = ["log" "-r" "all()"];
            lm = ["log" "-r" "user()"];
            n = ["new"];
            na = ["new" "--insert-after=@"];
            nb = ["new" "--insert-before=@" "--no-edit"];
            ne = ["next" "--edit"];
            ol = ["op" "log"];
            re = ["rebase"];
            rem = ["rebase" "-d" "main"];
            res = ["restore"];
            s = ["status"];
            sh = ["show"];
            sp = ["split"];
            spi = ["split" "-i"];
            sq = ["squash"];
            sqi = ["squash"];
            wa = ["workspace" "add"];
            wf = ["workspace" "forget"];
            wl = ["workspace" "list"];
            wr = ["workspace" "rename"];
          };

          templates = {
            draft_commit_description = ''
              concat(
                builtin_draft_commit_description,
                "\nJJ: ignore-rest\n",
                diff.git(),
              )
            '';
          };
        };
      };

      opencode = {
        commands = {
          "jj:change:describe" = ''
            ---
            description: Create well-formatted conventional commit messages using jujutsu.
            agent: build
            subtask: true
            ---

            Load the jujutsu-workflow skill and follow its instructions to:
            1. Analyze what changes are in the current commit
            2. Craft conventional commit message explaining WHY those changes were made
            3. Execute `jj describe -m "your message"` to set it on the current commit
            4. Do not create INTENTS-*.md file for this command
          '';

          "jj:gh:pr:create" = ''
            ---
            description: Create a GitHub pull request for the current jujutsu branch.
            agent: build
            subtask: true
            ---

            Load the jujutsu-workflow skill and follow its instructions to:
            1. Get the current branch name. Branch a are created as `push-*`
               for example `push-mymvvskypsow`
            2. If remote branch does not exist, create with `jj git push -c @`
            3. Check for all commits that the bookmark contains and synthesize a
               title and description for the PR. Include sections Summary,
               Details (Changes Made and Why These Changes Are Important)
               and Verification Steps
            3. Create Github Pull Request using `jj pr create --head <branch> --title "<title>" --description "<description>"`
            4. Watch for PR checks completion with `gh pr checks --watch <pr-number>`
            5. Do not create INTENTS-*.md file for this command
          '';
        };

        rules = ''
          IMPORTANT: only use jujutsu (jj) for version control. DO NOT use git.
        '';
      };

      zsh.shellAliases = {
        j = "jj";
        ja = "jj absorb";
        jab = "jj abandon";
        jbc = "jj bookmark create";
        jbd = "jj bookmark delete";
        jbl = "jj bookmark list";
        jbs = "jj bookmark set";
        jbsm = "jj bookmark set main -r @- --allow-backwards";
        jd = "jj diff";
        jde = "jj describe";
        jdem = "jj describe -m";
        jdep = "jj describe @-";
        jdepm = "jj describe @- -m";
        je = "jj edit";
        jen = "jj edit @+";
        jep = "jj edit @-";
        jg = "jj git";
        jgf = "jj git fetch";
        jgi = "jj git init";
        jgp = "jj git push";
        jgpc = "jj git push -c @";
        jl = "jj op log";
        jn = "jj new";
        jna = "jj new --insert-after=@";
        jnb = "jj new --insert-before=@ --no-edit";
        jne = "jj next --edit";
        jre = "jj rebase";
        jrem = "jj rebase -d main";
        jres = "jj restore";
        js = "jj status";
        jsh = "jj show";
        jsp = "jj split";
        jspi = "jj split -i";
        jsq = "jj squash";
        jsqi = "jj squash -i";
        jwa = "jj workspace add";
        jwf = "jj workspace forget";
        jwl = "jj workspace list";
        jwr = "jj workspace rename";
      };
    };
  };
}
