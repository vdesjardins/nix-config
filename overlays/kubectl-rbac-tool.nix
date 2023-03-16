inputs: _self: super: {
  kubectl-rbac-tool = super.buildGoModule {
    name = "kubectl-rbac-tool";

    src = inputs.kubectl-rbac-tool;

    vendorSha256 = "sha256-A4ToyhRqA26A/rHT5dPYXLktOFH+o5kajXQxmxZL+tM=";
  };
}
