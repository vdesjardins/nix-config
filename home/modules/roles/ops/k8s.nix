{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.k8s;
in {
  options.roles.ops.k8s = {
    enable = mkEnableOption "ops.k8s";
  };

  config = mkIf cfg.enable {
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
        cmctl
        crossplane-cli
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
        kubectl-rbac-tool
        kubectl-tap
        # kubectl-trace
        kubectl-tree
        kubectl-who-can
        kubectx
        kubent
        (wrapHelm
          kubernetes-helm
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
        kubectl-validate
        kubectl-explore # better explain
        kubecolor
        kubectl-neat
        cosign
        crane # tool to manage container images
        fluxcd
        kubeconform
        kubectl-example
        # kubectl-view-allocations
        kubelogin
        kubeshark
        kustomize
        oras
        rakkess # RBAC query tool
        telepresence2
        tilt
        velero
        python3Packages.kubernetes
      ]
      ++ lib.optionals stdenv.isLinux [
        popeye # unable to build on darwin
        kubectl-node-shell
      ];
  };
}
