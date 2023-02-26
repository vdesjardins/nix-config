inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-75lahv+pSzfJW7M7HikuUwR6HlNNUlcS3ZepQ3OYyjw=";
  };
}
