{ pkgs, ... }: {
  imports = [
    ../../../program/k9s
    ../../../program/kubectl
    ../../../program/istioctl
    ../../../program/stern
  ];

  home.packages = with pkgs; [
    buildpack
    kind
    unstable.kubeconform
    kubectx
    kubent
    kubernetes-helm
    kubetail
    kubeval
    kube3d
    unstable.kustomize
    unstable.rakkess # RBAC query tool
    skaffold
    starboard # security tools
    telepresence
    velero
  ];
}
