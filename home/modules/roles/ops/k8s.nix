{
  config,
  pkgs,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.k8s;
in {
  options.roles.ops.k8s = {
    enable = mkEnableOption "ops.k8s";

    localClusters = {
      kind.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable kind";
      };
      minikube.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable minikube";
      };
      k3d.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable k3d";
      };
    };

    developmentTools.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable extended Kubernetes development and observability tools";
    };

    securityTools.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Kubernetes security scanning tools";
    };

    extendedPlugins.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable specialized kubectl plugins and Python Kubernetes bindings";
    };
  };

  config = mkIf cfg.enable {
    modules.shell.tools = {
      flux9s.enable = true;
      k9s.enable = true;
      istioctl.enable = true;
      kubectl.enable = true;
      kubectl-ai.enable = cfg.developmentTools.enable;
      kubie.enable = true;
      stern.enable = true;
    };

    home.packages = with pkgs;
      [
        cmctl
        helmfile
        kubectx
        (wrapHelm
          kubernetes-helm
          {
            plugins = [
              kubernetes-helmPlugins.helm-diff
              kubernetes-helmPlugins.helm-git
            ];
          })
        crane
        fluxcd
        kubeconform
        kubelogin
        kustomize
        oras
        velero
      ]
      ++ lib.optional cfg.localClusters.kind.enable kind
      ++ lib.optional cfg.localClusters.k3d.enable k3d
      ++ lib.optional cfg.localClusters.minikube.enable (minikube.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            rm -f $out/bin/kubectl
          '';
      }))
      ++ lib.optionals cfg.developmentTools.enable [
        buildpack
        crossplane-cli
        helm-dashboard
        helm-docs
        kube-capacity
        kubespy
        kubetail
        kubeval
        kubeshark
        skaffold
        telepresence2
        tilt
      ]
      ++ lib.optionals cfg.securityTools.enable [
        starboard
        trivy
      ]
      ++ lib.optionals cfg.extendedPlugins.enable ([
          kubectl-images
          kubectl-tree
          kubectl-ktop
          kubectl-view-secret
          kubent
          kubectl-validate
          kubectl-explore
          kubecolor
          kubectl-neat
          kubectl-example
          rakkess
          python3Packages.kubernetes
        ]
        ++ (with my-packages; [
          ketall
          kubectl-blame
          kubectl-rbac-tool
          kubectl-tap
          kubectl-who-can
        ])
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          popeye
          kubectl-node-shell
        ]);
  };
}
