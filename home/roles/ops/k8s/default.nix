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
      kubectl-images
      kubectl-node-shell
      kubectl-rbac-tool
      # kubectl-trace
      kubectl-tree
      kubectl-view-utilization
      kubectx
      kubent
      (wrapHelm
        kubernetes-helm
        {
          plugins = [
            kubernetes-helmPlugins.helm-diff
            kubernetes-helmPlugins.helm-git
          ];
        })
      kubespy
      kubetail
      kubeval
      skaffold
      starboard # security tools
      trivy
      unstable.fluxcd
      unstable.kubeconform
      unstable.kubectl-example
      unstable.kubectl-who-can
      unstable.kubelogin
      unstable.kubeshark
      unstable.kustomize
      unstable.rakkess # RBAC query tool
      unstable.tilt
      velero
    ]
    ++ lib.optionals stdenv.isLinux [
      unstable.popeye # unable to build on darwin
      telepresence
      kubectl-sniff
    ];
}
