inputs: _self: super: {
  kube-lineage = super.buildGoModule {
    name = "kube-lineage";

    src = inputs.kube-lineage;

    vendorSha256 = "sha256-2Fjj7MotjF6XetYauEfFXvtfbvw7ZPL+1yRPILYFWoc=";
  };
}
