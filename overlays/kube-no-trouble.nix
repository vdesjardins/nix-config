inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-cbeclE01/ud8q6a5nbT5BoOBFUQpjtZDDSxoedqkQcQ=";
  };
}
