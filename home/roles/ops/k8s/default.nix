{ pkgs, ... }: {
  imports = [
    ../../../programs/k9s
    ../../../programs/kubectl
    ../../../programs/istioctl
    ../../../programs/stern
  ];

  home.packages = with pkgs; [
    buildpack
    helm-docs
    kail
    ketall # get all rersources
    kind
    kube-capacity
    kube-lineage
    kube3d
    kubectl-blame
    # kubectl-trace
    kubectl-view-utilization
    kubectx
    kubelogin
    kubent
    kubernetes-helm
    kubespy
    kubetail
    kubeval
    skaffold
    starboard # security tools
    trivy
    unstable.fluxcd
    unstable.kubeconform
    unstable.kubectl-example
    unstable.kustomize
    unstable.rakkess # RBAC query tool
    unstable.tilt
    velero
  ] ++ lib.optionals stdenv.isLinux [
    unstable.popeye # unable to build on darwin
    telepresence
    kubectl-sniff
  ];
}
