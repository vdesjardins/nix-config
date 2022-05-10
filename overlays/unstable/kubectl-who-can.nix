inputs: _self: super: {
  kubectl-who-can = super.buildGoModule {
    name = "kubectl-who-can";

    src = inputs.kubectl-who-can;

    doCheck = false;

    vendorSha256 = "sha256-MNqz1pg78laR5RrFfxNDpHjMcMvN0+qS5jqFnALGlY4=";
  };
}
