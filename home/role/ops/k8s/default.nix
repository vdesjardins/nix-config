{ pkgs, ... }: {
  imports = [
    ../../../program/k9s
    ../../../program/kubectl
    ../../../program/istioctl
    ../../../program/stern
  ];

  home.packages = with pkgs; [
    buildpack
    helm-docs
    kail
    kind
    kube-capacity
    kube-lineage
    kube3d
    kubectl-blame
    kubectl-trace
    kubectl-view-utilization
    kubectx
    kubelogin-oidc
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
