inputs: _self: super: {
  kube-lineage = super.buildGoModule {
    name = "kube-lineage";

    src = inputs.kube-lineage;

    vendorSha256 = "sha256-+p1QsUYPWf1YVYjkQs5V3bhcMZ4iBYLJFXPK2C6V12g=";
  };
}
