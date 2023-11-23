inputs: _self: super: {
  kubectl-tap = super.buildGoModule {
    name = "kubectl-tap";

    src = inputs.kubectl-tap;

    vendorHash = "sha256-6RbdlBRB3kzNQ986vWwLC+ReHeO5Es/fqzxWysLPYpA=";
  };
}
