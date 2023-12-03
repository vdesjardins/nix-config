inputs: _self: super: {
  helm-dashboard = super.buildGoModule {
    name = "helm-dashboard";

    src = inputs.helm-dashboard;

    vendorHash = "sha256-ROffm1SGYnhUcp46nzQ951eaeQdO1pb+f8AInm0eSq0=";

    doCheck = false;
  };
}
