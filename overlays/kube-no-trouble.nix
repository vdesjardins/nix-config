inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-WQwWBcwhFZxXPFO6h+5Y8VDM4urJGfZ6AOvhRoaSbpk=";
  };
}
