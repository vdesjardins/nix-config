inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-lzaP9cP3WzqZ3IDMwhEmXRLFStDGdPPtmMrvMwfJDm4=";
  };
}
