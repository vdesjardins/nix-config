inputs: _self: super: {
  helm-dashboard = super.buildGoModule {
    name = "helm-dashboard";

    src = inputs.helm-dashboard;

    vendorSha256 = "sha256-upmEF7OzeHBc65mzvEVe9LexgbL6x6jBR8o3VZn13gY=";

    doCheck = false;
  };
}
