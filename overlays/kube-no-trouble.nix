inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorSha256 = "sha256-3tijH0wTyeuoktjQ7fOiukT5F1/QXneatCvXo/DjxDo=";
  };
}
