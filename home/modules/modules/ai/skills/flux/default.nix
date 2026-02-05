{
  config,
  lib,
  my-packages,
  ...
}:
with lib; let
  cfg = config.modules.ai.skills.flux;
in {
  options.modules.ai.skills.flux = {
    enable = mkEnableOption "FluxCD skill";
    package = mkPackageOption my-packages "skill-flux" {};
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      settings.permission.bash = {
        "flux --version" = "allow";
        "flux check" = "allow";
        "flux create source git *" = "allow";
        "flux create source helm *" = "allow";
        "flux create kustomization *" = "allow";
        "flux create helmrelease *" = "allow";
        "flux get all" = "allow";
        "flux get sources all" = "allow";
        "flux get kustomization *" = "allow";
        "flux get helmrelease *" = "allow";
        "flux describe source git *" = "allow";
        "flux describe kustomization *" = "allow";
        "flux describe helmrelease *" = "allow";
        "flux reconcile source git *" = "allow";
        "flux reconcile kustomization *" = "allow";
        "flux reconcile helmrelease *" = "allow";
        "flux suspend kustomization *" = "allow";
        "flux suspend helmrelease *" = "allow";
        "flux resume kustomization *" = "allow";
        "flux resume helmrelease *" = "allow";
        "flux delete source git *" = "allow";
        "flux delete kustomization *" = "allow";
        "flux delete helmrelease *" = "allow";
        "kubectl get fluxcd.io" = "allow";
        "kubectl describe *" = "allow";
      };
    };

    xdg.configFile."opencode/skill/flux".source = "${cfg.package}/skills/flux";
  };
}
