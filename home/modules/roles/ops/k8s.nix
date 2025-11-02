{
  config,
  pkgs,
  lib,
  my-packages,
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
      kubectl-ai.enable = true;
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
        kind
        kube-capacity
        k3d
        kubectl-images
        # kubectl-trace
        kubectl-tree
        kubectl-ktop
        kubectl-view-secret
        kubectx
        kubent
        (wrapHelm
          kubernetes-helm
          {
            plugins = [
              kubernetes-helmPlugins.helm-diff
              kubernetes-helmPlugins.helm-git
              my-packages.helm-gcs
            ];
          })
        kubespy
        kubetail
        kubeval
        kubeshark
        minikube
        skaffold
        starboard # security tools
        trivy
        kubectl-validate
        kubectl-explore # better explain
        kubecolor
        kubectl-neat
        # cosign
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
      ++ (with my-packages; [
        ketall
        kubectl-blame
        kubectl-rbac-tool
        kubectl-tap
        kubectl-who-can
      ])
      ++ lib.optionals stdenv.isLinux [
        popeye # unable to build on darwin
        kubectl-node-shell
      ];
  };
}
