inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-nEc0fngop+0ju8hDu7nowBsioqCye15Jo1mRlM0TtlQ=";
  };
}
