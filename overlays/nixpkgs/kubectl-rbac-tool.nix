inputs: _self: super: {
  kubectl-rbac-tool = super.buildGoModule {
    name = "kubectl-rbac-tool";

    src = inputs.kubectl-rbac-tool;

    vendorHash = "sha256-eopF5XNML0z4WuAeg7S9dicOY1r3Z3B2dPH0oZQHUB4=";
  };
}
