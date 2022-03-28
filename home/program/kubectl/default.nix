{ config, pkgs, lib, ... }:
with lib;

mkMerge [
  (
    mkIf config.programs.zsh.enable {
      home.packages = with pkgs; [
        unstable.dyff
        unstable.kubectl
        gawk
        fzf
        jq
        bat
      ];

      programs.zsh = {
        initExtra = ''
          source ${config.xdg.configHome}/zsh/conf.d/kubectl_aliases

          KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"
        '';

        oh-my-zsh.plugins = [ "kubectl" ];

        shellGlobalAliases = {
          SL = "--show-labels";
          OJ = "-ojson";
          OJB = "-ojson |& bat -ljson";
          OY = "-oyaml";
          OYB = "-oyaml |& bat -lyaml";
          OW = "-owide";
        };

        shellAliases = {
          # Produce a period-delimited tree of all keys
          kgnop =
            "kubectl get nodes -o json | jq -c 'path(..)|[.[]|tostring]|join(\".\")'";
          kgpp =
            "kubectl get pods -o json | jq -c 'path(..)|[.[]|tostring]|join(\".\")'";

          # secret dump
          kgsecd =
            "kubectl get secret -o go-template='{{range $k,$v := .data}}{{$k}}={{$v|base64decode}}{{\"\\n\"}}{{end}}'";
          # events
          kge = "kubectl get events";
          kges = "kubectl get events --sort-by=.metadata.creationTimestamp";

          # pods
          kgc =
            "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,CONTAINERS:..containers[*].name'";
          kgimg =
            "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,IMAGES:.spec.containers[*].image'";
          kgpsa =
            "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,SA:.spec.serviceAccountName'";
          kgpoall-problems =
            "kubectl get pods --all-namespaces | grep -v -P '(Running|Completed)'";
          krmpo-evicted = "kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains(\"Evicted\")) | \"kubectl delete pods \\(.metadata.name) -n \\(.metadata.namespace)\"' | xargs -n 1 bash -c";

          kgpons = "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,NODE:.spec.nodeSelector'";
          # deployment
          krrd = "kubectl rollout restart deployment";

          # context and ns switching
          kns = "kube-ns-switch";
          kctx = "kube-ctx-switch";

          # edit
          ke = "kubectl edit";

          # top
          ktp = "kc top pods";
          ktc = "kc top pods --containers=true";
          ktn = "kc top nodes";

          # certs
          kube-get-certs = ''kubectl get certificates --all-namespaces -o jsonpath='{range .items[?(@.spec.commonName!="")]}{.spec.commonName}{"  "}{.status.notAfter}{" "}' | sort'';

          # events
          kgesw = "kubectl get events --field-selector type=Warning";

          # nodes
          kgno = "kubectl get nodes -o wide --label-columns topology.kubernetes.io/zone";
        };
      };

      xdg.configFile."zsh/functions/kube-inspect".source =
        ./zsh/functions/kube-inspect;
      xdg.configFile."zsh/functions/kube-ctx-switch".source =
        ./zsh/functions/kube-ctx-switch;
      xdg.configFile."zsh/functions/kube-ctx-switch-current".source =
        ./zsh/functions/kube-ctx-switch-current;
      xdg.configFile."zsh/functions/kube-ns-switch".source =
        ./zsh/functions/kube-ns-switch;
      xdg.configFile."zsh/functions/kube-get-pod-images".source =
        ./zsh/functions/kube-get-pod-images;

      xdg.configFile."zsh/conf.d/kubectl_aliases".source =
        "${pkgs.kubectl-aliases}/share/kubectl-aliases/kubectl_aliases";
    }
  )
]
