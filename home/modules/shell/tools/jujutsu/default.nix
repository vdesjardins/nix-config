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
    home.packages = with pkgs.unstable; [
      difftastic
    ];

    programs = {
      jujutsu = {
        inherit (cfg) enable;

        package = pkgs.unstable.jujutsu;

        settings = {
          user = {
            email = "vdesjardins@gmail.com";
            name = "Vincent Desjardins";
          };
          ui = {
            diff-editor = "meld-3";
            diff = {
              tool = ["difft" "--color=always" "$left" "$right"];
            };
            merge-editor = "meld";
            paginate = "never";
          };
        };
      };

      zsh.shellAliases = {
        j = "jj";
        jd = "jj diff";
        jg = "jj git";
        jgp = "jj git push";
        jgf = "jj git fetch";
        ja = "jj abandon";
        jr = "jj restore";
        jm = "jj describe";
        js = "jj split";
        jbr = "jj branch list";
        jbc = "jj branch create";
        jbd = "jj branch delete";
        jl = "jj op log";
      };
    };
  };
}
