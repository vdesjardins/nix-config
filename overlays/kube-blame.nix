inputs: _self: super: {
  kubectl-blame = super.buildGoModule {
    name = "kubectl-blame";

    src = inputs.kubectl-blame;

    vendorHash = "sha256-f3JqDRqTvnmdpdkMVorKVJI1hoRlLDtVbZi2VB/an/k=";
  };
}
