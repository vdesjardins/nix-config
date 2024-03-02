{pkgs, ...}: {
  modules.shell.tools = {
    k9s.enable = true;
    istioctl.enable = true;
    kubectl.enable = true;
    kubie.enable = true;
    stern.enable = true;
  };

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
      kubectl-tap
      # kubectl-trace
      kubectl-tree
      kubectl-who-can
      kubectx
      kubent
      (wrapHelm
        unstable.kubernetes-helm
        {
          plugins = [
            kubernetes-helmPlugins.helm-diff
            kubernetes-helmPlugins.helm-git
            helm-gcs
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
