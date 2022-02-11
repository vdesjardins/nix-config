{ pkgs, ... }: {
  imports = [
    ../../../program/k9s
    ../../../program/kubectl
    ../../../program/istioctl
    ../../../program/stern
  ];

  home.packages = with pkgs; [
    buildpack
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
    velero
  ] ++ lib.optionals stdenv.isLinux [
    telepresence
    kubectl-sniff
  ];
}
