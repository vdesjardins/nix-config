{
  config,
  pkgs,
  lib,
  ...
}:
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
          gnugrep
        ];

        programs.zsh = {
          initExtra = ''
            source ${config.xdg.configHome}/zsh/conf.d/kubectl_aliases

            KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"
          '';

          oh-my-zsh.plugins = ["kubectl"];

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
            kgnop = "kubectl get nodes -o json | jq -c 'path(..)|[.[]|tostring]|join(\".\")'";
            kgpp = "kubectl get pods -o json | jq -c 'path(..)|[.[]|tostring]|join(\".\")'";

            # secret dump
            kgsecd = "kubectl get secret -o go-template='{{range $k,$v := .data}}{{$k}}={{$v|base64decode}}{{\"\\n\"}}{{end}}'";
            # events
            kge = "kubectl get events";
            kges = "kubectl get events --sort-by=.metadata.creationTimestamp";

            # pods
            kgc = "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,CONTAINERS:.spec.containers[*].name,INIT:.spec.initContainers[*].name,EPHEMERAL:.spec.ephemeralContainers[*].name'";
            kgimg = "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,IMAGES:.spec.containers[*].image,INIT_IMAGES:.spec.template.spec.initContainers[*].image'";
            kgpsa = "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,SA:.spec.serviceAccountName'";
            kgppending = "kubectl get pods --field-selector=status.phase=Pending";
            krmpo-evicted = "kubectl get pods --all-namespaces -o json | jq '.items[] | select(.status.reason!=null) | select(.status.reason | contains(\"Evicted\")) | \"kubectl delete pods \\(.metadata.name) -n \\(.metadata.namespace)\"' | xargs -n 1 bash -c";

            kgpons = "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,NODE:.spec.nodeSelector'";
            kgpot = "kubectl get pods -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,NODE:.spec.tolerations'";
            kgpoon = "kubectl get pods -A -o=custom-columns='NAMESPACE:.metadata.namespace,POD:.metadata.name,OWNER:.metadata.ownerReferences[*].kind,NODE:.spec.nodeName' | rg -vi 'daemonset|node'";
            kgpo-errors = "kubectl get pods -A | rg -v 'Running|Completed'";

            # deployment
            krrd = "kubectl rollout restart deployment";
            kgdimg = "kubectl get deployment -o=custom-columns='NAMESPACE:.metadata.namespace,DEPLOYMENT:.metadata.name,IMAGES:.spec.template.spec.containers[*].image,INIT_IMAGES:.spec.template.spec.initContainers[*].image'";

            # context and ns switching
            kns = "kube-ns-switch";
            knsd = "kube-ns-switch-detach";
            kctx = "kube-ctx-switch";
            kctxc = "kube-ctx-switch-current";
            kctxd = "kube-ctx-switch-detach";

            # edit
            ke = "kubectl edit";

            # top
            ktp = "kc top pods";
            ktc = "kc top pods --containers=true";
            ktn = "kc top nodes";

            # certs
            kube-get-certs = ''kubectl get certificates --all-namespaces -o jsonpath='{range .items[?(@.spec.commonName!="")]}{.spec.commonName}{"  "}{.status.notAfter}{" "}' | sort'';

            # events
            kgesw = "kubectl get events --field-selector type=Warning --sort-by='.lastTimestamp'";

            # nodes
            kgno = "kubectl get nodes -o wide --label-columns topology.kubernetes.io/zone";
            kgnot = "kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints";
            kgno-gke = "kubectl get nodes -o=\"custom-columns=NAME:.metadata.name,TYPE:.metadata.labels.node\\.kubernetes\\.io/instance-type,SPOT:.metadata.labels.cloud\\.google\\.com/gke-spot,PREEMP:.metadata.labels.cloud\\.google\\.com/gke-preemptible\"";

            # all objects
            kgaobj = "kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found";

            # config
            kc = "kubectl config";
            kcgu = "kubectl config get-users";
            kcgcl = "kubectl config get-clusters";
          };
        };

        xdg.configFile."zsh/functions/kube-inspect".source =
          ./zsh/functions/kube-inspect;
        xdg.configFile."zsh/functions/kube-ctx-switch".source =
          ./zsh/functions/kube-ctx-switch;
        xdg.configFile."zsh/functions/kube-ctx-switch-current".source =
          ./zsh/functions/kube-ctx-switch-current;
        xdg.configFile."zsh/functions/kube-ctx-switch-detach".source =
          ./zsh/functions/kube-ctx-switch-detach;
        xdg.configFile."zsh/functions/kube-ns-switch".source =
          ./zsh/functions/kube-ns-switch;
        xdg.configFile."zsh/functions/kube-ns-switch-detach".source =
          ./zsh/functions/kube-ns-switch-detach;
        xdg.configFile."zsh/functions/kube-get-pod-images".source =
          ./zsh/functions/kube-get-pod-images;
        xdg.configFile."zsh/functions/kube-updateconfig-aws".source =
          ./zsh/functions/kube-updateconfig-aws;
        xdg.configFile."zsh/functions/kube-updateconfig-aws-all".source =
          ./zsh/functions/kube-updateconfig-aws-all;
        xdg.configFile."zsh/functions/kube-get-node-pods".source =
          ./zsh/functions/kube-get-node-pods;
        xdg.configFile."zsh/functions/kube-node-connect".source =
          ./zsh/functions/kube-node-connect;

        xdg.configFile."zsh/conf.d/kubectl_aliases".source = "${pkgs.kubectl-aliases}/share/kubectl-aliases/kubectl_aliases";
      }
    )
  ]
