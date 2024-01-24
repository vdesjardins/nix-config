{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.kubie;
in {
  options.modules.shell.tools.kubie = {
    enable = mkEnableOption "kubie";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [kubie];

    home.file.".kube/kubie.yaml".source =
      ./kubie.yaml;

    programs = {
      zsh.shellAliases = {
        kbn = "kubie ns";
        kbx = "kubie ctx";
        kbe = "kubie exec";
        kbs = "wezterm cli split-pane --top-level kubie ctx $(kubie info ctx) -n $(kubie info ns || echo 'default')";
      };

      zsh.initExtra =
        /*
        bash
        */
        ''
          # example: kube-exec-each-cluster 'rg dev' default kubectl get svc
          function kube-exec-each-cluster() {
              filter=$1
              namespace=$2
              shift 2

              while read -r ctx; do
                  kubie exec "$ctx" "$namespace" "$@"
              done < <(eval "kubectl config get-contexts --no-headers -oname | $filter")
            }
        '';
    };
  };
}
