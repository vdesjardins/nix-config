inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-5w8WE6gcAz+ZBtx2KHaORa78pe3jba5gFwGcJJY0XZA=";
  };
}
