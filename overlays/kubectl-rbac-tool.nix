inputs: _self: super: {
  kubectl-rbac-tool = super.buildGoModule {
    name = "kubectl-rbac-tool";

    src = inputs.kubectl-rbac-tool;

    vendorSha256 = "sha256-ICyDzKbp6qYu5Ib5nsoP3cCL/9J/7KrS6cTpDmwoh3E=";
  };
}
