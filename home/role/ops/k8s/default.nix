{ pkgs, ... }: {
  imports = [
    ../../../program/k9s
    ../../../program/kubectl
    ../../../program/istioctl
    ../../../program/stern
  ];

  home.packages = with pkgs; [
    buildpack
    unstable.fluxcd
    helm-docs
    kail
    kind
    kube-capacity
    kube-lineage
    kubectl-blame
    unstable.kubeconform
    unstable.kubectl-example
    kubectl-trace
    kubectl-view-utilization
    kubectx
    kubelogin-oidc
    kubent
    kubernetes-helm
    kubespy
    kubetail
    kubeval
    kube3d
    unstable.kustomize
    unstable.rakkess # RBAC query tool
    skaffold
    starboard # security tools
    unstable.tilt
    trivy
    velero
  ] ++ lib.optionals stdenv.isLinux [
    unstable.popeye # unable to build on darwin
    telepresence
    kubectl-sniff
  ];
}
