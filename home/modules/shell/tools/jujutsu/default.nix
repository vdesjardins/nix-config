{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.jujutsu;
in {
  options.modules.shell.tools.jujutsu = {
    enable = mkEnableOption "jujutsu scm";
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
            email = "vdesjardins@gmail.com";
            name = "Vincent Desjardins";
          };
          ui = {
            default-command = "log";
            pager = "less -FRX";
            diff = {
              tool = ["difft" "--color=always" "$left" "$right"];
            };
            merge-editor = "meld";
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
        jsi = "jj squash";
      };
    };
  };
}
