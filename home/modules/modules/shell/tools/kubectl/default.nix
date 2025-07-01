{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.kubectl;
in {
  options.modules.shell.tools.kubectl = {
    enable = mkEnableOption "kubectl";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dyff
      kubectl
      gawk
      fzf
      jq
      bat
      gnugrep
      kubecolor
    ];

    programs.zsh = {
      initContent = ''
        source ${config.xdg.configHome}/zsh/conf.d/kubectl_aliases

        KUBECTL_EXTERNAL_DIFF="dyff between --omit-header --set-exit-code"

        compdef kubecolor=kubectl
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
        kubectl = "kubecolor";

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
        ktp = "kubectl top pods";
        ktc = "kubectl top pods --containers=true";
        ktn = "kubectl top nodes";

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

        kgpcapadd = "kubectl get pods -A -o=custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,CAPABILITIES:.spec.containers[].securityContext.capabilities.add'";
        kgpcapdrop = "kubectl get pods -A -o=custom-columns='NAMESPACE:.metadata.namespace,NAME:.metadata.name,CAPABILITIES:.spec.containers[].securityContext.capabilities.drop'";

        # CRDs
        kgcrds = "kubectl get crd -o=custom-columns=NAME:.metadata.name,SCOPE:.spec.scope";
      };
    };

    xdg.configFile = {
      "zsh/functions/kube-inspect".source =
        ./zsh/functions/kube-inspect;
      "zsh/functions/kube-ctx-switch".source =
        ./zsh/functions/kube-ctx-switch;
      "zsh/functions/kube-ctx-switch-current".source =
        ./zsh/functions/kube-ctx-switch-current;
      "zsh/functions/kube-ctx-switch-detach".source =
        ./zsh/functions/kube-ctx-switch-detach;
      "zsh/functions/kube-ns-switch".source =
        ./zsh/functions/kube-ns-switch;
      "zsh/functions/kube-ns-switch-detach".source =
        ./zsh/functions/kube-ns-switch-detach;
      "zsh/functions/kube-get-pod-images".source =
        ./zsh/functions/kube-get-pod-images;
      "zsh/functions/kube-updateconfig-aws".source =
        ./zsh/functions/kube-updateconfig-aws;
      "zsh/functions/kube-updateconfig-aws-all".source =
        ./zsh/functions/kube-updateconfig-aws-all;
      "zsh/functions/kube-get-node-pods".source =
        ./zsh/functions/kube-get-node-pods;
      "zsh/functions/kube-node-connect".source =
        ./zsh/functions/kube-node-connect;

      "zsh/conf.d/kubectl_aliases".source = "${pkgs.kubectl-aliases}/share/kubectl-aliases/kubectl_aliases";
    };
  };
}
