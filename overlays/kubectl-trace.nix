inputs: _self: super: {
  kubectl-trace = super.buildGoModule {
    name = "kubectl-trace";

    src = inputs.kubectl-trace;

    doCheck = false;

    vendorSha256 = "sha256-qOQCnIym+aisSGUlj8XUYjLKX0BQ6FGJtiXVOo9EMvE=";
  };
}
