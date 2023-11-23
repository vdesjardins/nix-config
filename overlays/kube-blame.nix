inputs: _self: super: {
  kubectl-blame = super.buildGoModule {
    name = "kubectl-blame";

    src = inputs.kubectl-blame;

    vendorHash = "sha256-L2kJiQXbe5wdB1ERb+R8MoOjddRMLwCKniCqpeIMxF8=";
  };
}
