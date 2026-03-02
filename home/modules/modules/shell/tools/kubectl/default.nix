{
  config,
  my-packages,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.kubectl;

  kubercFile = (pkgs.formats.yaml {}).generate "kuberc" kuberc;

  kuberc = {
    apiVersion = "kubectl.config.k8s.io/v1beta1";
    kind = "Preference";
    defaults = [
      {
        command = "apply";
        options = [
          {
            name = "server-side";
            default = "true";
          }
        ];
      }
      {
        command = "delete";
        options = [
          {
            name = "interactive";
            default = "true";
          }
        ];
      }
    ];
  };
in {
  options.modules.shell.tools.kubectl = {
    enable = mkEnableOption "kubectl";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        dyff
        kubectl
        gawk
        fzf
        jq
        bat
        gnugrep
        kubecolor
      ];
      sessionVariables = {
        KUBECTL_EXTERNAL_DIFF = "dyff between --omit-header --set-exit-code";
        KUBECTL_KYAML = "true";
      };
      file = {
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
        "zsh/functions/kube-get-node-pods".source =
          ./zsh/functions/kube-get-node-pods;
        "zsh/functions/kube-node-connect".source =
          ./zsh/functions/kube-node-connect;
        "zsh/conf.d/kubectl_aliases".source = "${my-packages.kubectl-aliases}/share/kubectl-aliases/kubectl_aliases";
        ".kube/kuberc".source = kubercFile;
      };
    };

    programs.zsh = {
      initContent = ''
        source ${config.xdg.configHome}/zsh/conf.d/kubectl_aliases

        compdef kubecolor=kubectl
      '';

      oh-my-zsh.plugins = ["kubectl"];

      shellGlobalAliases = {
        SL = "--show-labels";
        OJ = "-ojson";
        OJB = "-ojson |& bat -ljson";
        OY = "-oyaml";
        OK = "-okyaml";
        OYB = "-oyaml |& bat -lyaml";
        OKB = "-okyaml |& bat -lyaml";
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

    programs.nushell = {
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

        # edit
        ke = "kubectl edit";

        # top
        ktp = "kubectl top pods";
        ktc = "kubectl top pods --containers=true";
        ktn = "kubectl top nodes";

        # certs
        kube-get-certs = "kubectl get certificates --all-namespaces -o jsonpath='{range .items[?(@.spec.commonName!=\"\")]}{.spec.commonName}{\"  \"}{.status.notAfter}{\" \"}' | sort";

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

      extraConfig = ''
        # Source kubectl aliases
        source ${my-packages.kubectl-aliases}/share/kubectl-aliases/kubectl_aliases.nu

        # Create a new tmux session with dedicated kubeconfig
        def kube-ctx-switch [context_name?: string] {
                  $env.KUBECONFIG = $"($env.HOME)/.kube/config"

                  mut ctx = if ($context_name | is-empty) {
                    kubectl config get-contexts --no-headers -o name | lines | fzf
                  } else {
                    $context_name
                  }

                  if ($ctx | is-empty) {
                    print "no context provided."
                    return
                  }

                  let cluster = (
                    kubectl config view -ojson
                    | from json
                    | get contexts
                    | where name == $ctx
                    | get 0.context.cluster
                  )

                  # Check if context is EKS
                  mut aws_context = ""
                  mut aws_profile = ""
                  let aws_account_id = ($cluster | split row ':' | get 4? | default "")

                  if ($aws_account_id | is-not-empty) {
                    $aws_profile = (
                      jc --ini < ~/.aws/config
                      | from json
                      | transpose key value
                      | where value.sso_account_id? == $aws_account_id
                      | get key
                      | each { |k| $k | split row ' ' | get 1 }
                      | fzf
                    )
                    $aws_context = $"export AWS_PROFILE=($aws_profile)"

                    if $ctx == $cluster {
                      $ctx = ($ctx | split row '/' | get 1)
                    }
                  }

                  # Check if context is GKE
                  mut context_name_short = $ctx
                  if ($ctx | str starts-with 'gke_') {
                    let parts = ($ctx | split row '_')
                    $context_name_short = $"($parts | get 2)-($parts | get 3)"
                  }

                  let context_file = ($context_name_short | str replace ':' '_')
                  let session_name = $"➜ ($context_file)"

                  # Check if session exists
                  let sessions = (tmux list-session | lines | each { |line| $line | split row ':' | get 0 })
                  if ($session_name in $sessions) {
                    tmux switch-client -t $session_name
                    return
                  }

                  let dir = $"($env.HOME)/.config/my-kubeconfig"
                  mkdir $dir
                  let kubeconfig = $"($dir)/($context_file)-config"
                  let startup_script = $"($dir)/($context_file)-startup-script.sh"
                  cp ~/.kube/config $kubeconfig

                  let script_content = $"#!/usr/bin/env nu
        ($aws_context)
        $env.KUBECONFIG = \"($kubeconfig)\"
        kubectl config use-context \"($ctx)\"
        nu"

                  $script_content | save -f $startup_script
                  chmod +x $startup_script

                  if ("TMUX" in $env) {
                    tmux new-session -d -s $session_name $startup_script
                    tmux setenv -t $session_name KUBECONFIG $kubeconfig
                    tmux setenv -t $session_name AWS_PROFILE $aws_profile
                    tmux switch-client -t $session_name
                  } else if ("ZELLIJ" in $env) {
                    zellij ac new-tab -n $session_name
                    zellij r --close-on-exit -- $startup_script
                  } else {
                    print -e "unknown shell multiplexer"
                    return
                  }
        }
      '';
    };
  };
}
