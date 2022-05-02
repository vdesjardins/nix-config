inputs: _self: super: {
  ketall = super.buildGoModule {
    name = "ketall";

    src = inputs.ketall;

    vendorSha256 = "sha256-x9r3nX9p8ayRA7JmSWLbe7z0nWT/DZSjUbmbtrdb20A=";
  };
}
