inputs: _self: super: {
  ketall = super.buildGoModule {
    name = "ketall";

    src = inputs.ketall;

    vendorHash = "sha256-aSgVzygYtQL64rZaJACztDHfz2fzn/an733NdAovy6I=";
  };
}
