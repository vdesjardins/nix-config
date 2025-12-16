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
            a = ["abandon"];
            r = ["restore"];
            m = ["describe" "-m"];
            bl = ["bookmark" "list"];
            bc = ["bookmark" "create"];
            bd = ["bookmark" "delete"];
            bs = ["bookmark" "set"];
            bsm = ["bookmark" "set" "main" "-r" "@-" "--allow-backwards"];
            ol = ["op" "log"];
            e = ["edit"];
            ne = ["next" "--edit"];
            nb = ["new" "--insert-before"];
            n = ["new" "--insert-before=@" "--no-edit"];
            na = ["new" "--insert-after=@"];
            mp = ["describe" "@-" "-m"];
            sh = ["show"];
            sq = ["squash"];
            sqi = ["squash"];
            s = ["status"];
            lg = ["log" "-r" "all()"];
            lm = ["log" "-r" "user()"];
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
        ja = "jj abandon";
        jr = "jj restore";
        jm = "jj describe -m";
        jbl = "jj bookmark list";
        jbc = "jj bookmark create";
        jbd = "jj bookmark delete";
        jbs = "jj bookmark set";
        jbsm = "jj bookmark set main -r @- --allow-backwards";
        jl = "jj op log";
        je = "jj edit";
        jne = "jj next --edit";
        jnb = "jj new --insert-before";
        jn = "jj new --insert-before=@ --no-edit";
        jna = "jj new --insert-after=@";
        jmp = "jj describe @- -m";
        jsh = "jj show";
        jsq = "jj squash";
        jsqi = "jj squash -i";
        js = "jj status";
      };
    };
  };
}
