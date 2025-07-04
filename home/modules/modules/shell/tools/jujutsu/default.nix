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

          git = {
            auto-local-bookmark = true;
          };

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
            m = ["describe"];
            br = ["bookmark" "list"];
            bc = ["bookmark" "create"];
            bd = ["bookmark" "delete"];
            bs = ["bookmark" "set"];
            bsm = ["bookmark" "set" "main" "-r" "@-" "--allow-backwards"];
            ol = ["op" "log"];
            e = ["edit"];
            ne = ["next" "--edit"];
            nb = ["new" "-B"];
            n = ["new" "--insert-before=@" "--no-edit"];
            mp = ["describe" "@-" "-m"];
            sh = ["show"];
            s = ["squash"];
            si = ["squash"];
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
        jm = "jj describe";
        jbr = "jj bookmark list";
        jbc = "jj bookmark create";
        jbd = "jj bookmark delete";
        jbs = "jj bookmark set";
        jbsm = "jj bookmark set main -r @- --allow-backwards";
        jl = "jj op log";
        je = "jj edit";
        jne = "jj next --edit";
        jnb = "jj new -B";
        jn = "jj new --insert-before=@ --no-edit";
        jmp = "jj describe @- -m";
        jsh = "jj show";
        js = "jj squash";
        jsi = "jj squash -i";
        jst = "jj status";
      };
    };
  };
}
