inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-f6KNZcKVzRCm9bV1qIW3EagbGo96IHs3O8Vd5nXKep4=";
  };
}
