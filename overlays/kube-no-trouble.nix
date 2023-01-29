inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-ZtvCFe1CkHxu+RLPHvhf3s9fK+5KlYGpNGst4G3G4BM=";
  };
}
