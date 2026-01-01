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

            ## Features:
            - Runs pre-commit checks by default (lint, build, generate docs)
            - Uses conventional commit format with descriptive emojis

            ## Usage:
            - `jj-describe [refs:<ref>]` - Standard with pre-commit checks
            - `jj-describe [refs:<ref>] --no-verify` - Skip pre-commit checks

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
            - DO NOT use any `git` commands. only `jj` commands are allowed.
            - Run pre-commit checks (unless --no-verify)
            - Analyze the changes in the working copy
              - Check for `INTENTS-*` files, You MUST run `jj status`.
              - Do not check for other INTENTS files other than those reported by `jj status`.
              - If no such files exist from the `jj status` command, generate from the diff with the command `jj diff`.
            - If `refs:`, use the corresponding refs as commit footer.
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
