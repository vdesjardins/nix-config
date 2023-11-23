inputs: _self: super: {
  kubectl-rbac-tool = super.buildGoModule {
    name = "kubectl-rbac-tool";

    src = inputs.kubectl-rbac-tool;

    vendorHash = "sha256-A49AkQRR2RKShzGloHfDnI8pxRqm9Im9l2kASLXoJjA=";
  };
}
