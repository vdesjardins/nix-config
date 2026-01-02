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
            de = ["describe" "-m"];
            dep = ["describe" "@-" "-m"];
            e = ["edit"];
            g = ["git"];
            gf = ["git" "fetch"];
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
          "jj:describe" = ''
            ---
            description: Create well-formatted conventional commit messages using jujutsu.
            agent: build
            subtask: true
            ---

            Create well-formatted conventional commit messages using jujutsu
            that follows the following guidelines:

            ## Features:
            - Runs pre-commit checks by default (lint, build, generate docs)
            - Uses conventional commit format with descriptive emojis

            ## Commit Types:
            - ✨ feat: New features
            - 🐛 fix: Bug fixes
            - 📝 docs: Documentation changes
            - ♻️ refactor: Code restructuring without changing functionality
            - 🎨 style: Code formatting, missing semicolons, etc.
            - ⚡️ perf: Performance improvements
            - ✅ test: Adding or correcting tests
            - 🧑‍💻 chore: Tooling, configuration, maintenance
            - 🚧 wip: Work in progress
            - 🔥 remove: Removing code or files
            - 🚑 hotfix: Critical fixes
            - 🔒 security: Security improvements

            ## Process
            - Run pre-commit checks (unless --no-verify)
            - DO NOT use any `git` commands. Only `jj` commands are allowed.
            - DO NOT use shell inspection commands like `ls`, `find` to locate files.
            - To create the message, check for changes in the working copy:
              1. Run `jj status` to get the working copy status
              2. Check the output of `jj status` to see if any `INTENTS-*` files are listed
              3. If `INTENTS-*` files exist in the status output:
                 - Read the INTENTS file from disk to get the original prompt
                 - Use the content to generate the commit message based on the changes
              4. If NO `INTENTS-*` files are listed in the `jj status` output:
                 - Run `jj diff` to analyze the changes
                 - Generate the commit message from the diff output
            - If `refs:` is specified, use the corresponding refs as commit footer.
            - Include a scope if applicable: `type(scope): description`
            - Add a body for complex changes. Explain why.
            - To set the commit message, run `jj describe -m "<message>"`.

            ## Best Practices
            - Write in imperative mood.
            - Explain the WHY, not the WHAT.
            - Reference issues/PRs when relevant.
          '';
        };

        settings.permission.bash = {
          "jj describe" = "allow";
          "jj diff" = "allow";
          "jj status" = "allow";
        };
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
        jde = "jj describe -m";
        jdep = "jj describe @- -m";
        je = "jj edit";
        jg = "jj git";
        jgf = "jj git fetch";
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
      };
    };
  };
}
