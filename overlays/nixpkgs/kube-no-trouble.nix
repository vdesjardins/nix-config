inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorHash = "sha256-kkacGyTP28fHG4X0IVnE2kbkkoLoAbmVbe/36gm+3X8=";
  };
}
