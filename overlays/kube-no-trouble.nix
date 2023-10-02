inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-Y0n8tDQeiBdEnCbIrI2je8UCvK72REDBnAH+AtwQf1Q=";
  };
}
