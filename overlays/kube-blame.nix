inputs: _self: super: {
  kubectl-blame = super.buildGoModule {
    name = "kubectl-blame";

    src = inputs.kubectl-blame;

    vendorSha256 = "sha256-E9NxmDVD/cM8TwtUbHIj2jNa9/roeUSO8qpP/g6EaQk=";
  };
}
