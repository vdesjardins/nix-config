inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-l11eKEzS1jMoQYEsmfiM/mOfEL9P17hcCOBQM9LcjPw=";
  };
}
