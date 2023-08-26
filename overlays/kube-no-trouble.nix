inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-ONy4wOOSkvC6fn4iSuuqfHZkAiuPo0pLzpmzl2qGbfE=";
  };
}
