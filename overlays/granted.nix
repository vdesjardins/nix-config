inputs: _self: super: {
  granted = super.buildGoModule {
    name = "granted";

    src = inputs.granted;

    vendorSha256 = "0000000000000000000000000000000000000000000000000000";
  };
}
