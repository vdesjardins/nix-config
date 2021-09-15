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
    kubectx
    kubernetes-helm
    kubetail
    kubeval
    kube3d
    kustomize
    skaffold
    telepresence
    velero
  ];
}
