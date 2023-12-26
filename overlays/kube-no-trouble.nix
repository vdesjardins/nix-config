inputs: _self: super: {
  kubent = super.buildGoModule {
    name = "kubent";

    src = inputs.kube-no-trouble;

    vendorHash = "sha256-bTKt7BBJviKGD4E53dNEwiDN9+lxL06MRKkZZbxAhsw=";
  };
}
