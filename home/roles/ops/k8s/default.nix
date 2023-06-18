{pkgs, ...}: {
  imports = [
    ../../../programs/k9s
    ../../../programs/kubectl
    ../../../programs/istioctl
    ../../../programs/stern
  ];

  home.packages = with pkgs;
    [
      buildpack
      helm-dashboard
      helm-docs
      helmfile
      # kail
      ketall # get all rersources
      kind
      kube-capacity
      kube-lineage
      kube3d
      kubectl-blame
      kubectl-hns
      kubectl-images
      kubectl-node-shell
      kubectl-rbac-tool
      kubectl-tap
      # kubectl-trace
      kubectl-tree
      kubectx
      kubent
      (wrapHelm
        unstable.kubernetes-helm
        {
          plugins = [
            kubernetes-helmPlugins.helm-diff
            kubernetes-helmPlugins.helm-git
          ];
        })
      kubespy
      kubetail
      kubeval
      minikube
      skaffold
      starboard # security tools
      trivy
      unstable.cosign
      unstable.crane # tool to manage container images
      unstable.fluxcd
      unstable.kubeconform
      unstable.kubectl-example
      unstable.kubectl-who-can
      unstable.kubectl-view-allocations
      unstable.kubelogin
      unstable.kubeshark
      unstable.kustomize
      unstable.oras
      unstable.rakkess # RBAC query tool
      unstable.telepresence2
      unstable.tilt
      velero
    ]
    ++ lib.optionals stdenv.isLinux [
      unstable.popeye # unable to build on darwin
    ];
}
