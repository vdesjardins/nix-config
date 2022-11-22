inputs: _self: super: {
  ketall = super.buildGoModule {
    name = "ketall";

    src = inputs.ketall;

    vendorSha256 = "sha256-aSgVzygYtQL64rZaJACztDHfz2fzn/an733NdAovy6I=";
  };
}
