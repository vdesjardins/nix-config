inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-XXf6CPPHVvCTZA4Ve5/wmlgXQ/gZZUW0W/jXA0bJgLA=";
  };
}
