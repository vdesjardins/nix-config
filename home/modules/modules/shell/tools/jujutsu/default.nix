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
            d = ["diff"];
            g = ["git"];
            gp = ["git" "push"];
            gpc = ["git" "push" "-c" "@"];
            gf = ["git" "fetch"];
            a = ["absorb"];
            ab = ["abandon"];
            m = ["describe" "-m"];
            bl = ["bookmark" "list"];
            bc = ["bookmark" "create"];
            bd = ["bookmark" "delete"];
            bs = ["bookmark" "set"];
            bsm = ["bookmark" "set" "main" "-r" "@-" "--allow-backwards"];
            ol = ["op" "log"];
            e = ["edit"];
            n = ["new"];
            ne = ["next" "--edit"];
            nb = ["new" "--insert-before=@" "--no-edit"];
            na = ["new" "--insert-after=@"];
            mp = ["describe" "@-" "-m"];
            r = ["restore"];
            rm = ["rebase" "-d" "main"];
            sh = ["show"];
            sq = ["squash"];
            sqi = ["squash"];
            sp = ["split"];
            spi = ["split" "-i"];
            s = ["status"];
            lg = ["log" "-r" "all()"];
            lm = ["log" "-r" "user()"];
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

      zsh.shellAliases = {
        j = "jj";
        jd = "jj diff";
        jg = "jj git";
        jgp = "jj git push";
        jgpc = "jj git push -c @";
        jgf = "jj git fetch";
        ja = "jj absorb";
        jab = "jj abandon";
        jm = "jj describe -m";
        jbl = "jj bookmark list";
        jbc = "jj bookmark create";
        jbd = "jj bookmark delete";
        jbs = "jj bookmark set";
        jbsm = "jj bookmark set main -r @- --allow-backwards";
        jl = "jj op log";
        je = "jj edit";
        jn = "jj new";
        jne = "jj next --edit";
        jnb = "jj new --insert-before=@ --no-edit";
        jna = "jj new --insert-after=@";
        jmp = "jj describe @- -m";
        jr = "jj restore";
        jrm = "jj rebase -d main";
        jsh = "jj show";
        jsq = "jj squash";
        jsqi = "jj squash -i";
        jsp = "jj split";
        jspi = "jj split -i";
        js = "jj status";
      };
    };
  };
}
