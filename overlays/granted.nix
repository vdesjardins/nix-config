inputs: _self: super: {
  granted = super.buildGoModule {
    name = "granted";

    src = inputs.granted;

    vendorSha256 = "sha256-P7HeJUdVlqrTEMVXGlvcCr9ezEmqIw5AX/+xdcFQoH4=";

    postInstall = ''
      mkdir -p $out/share/granted
      cp ./scripts/assume $out/share/granted/assume

      ln -s $out/bin/granted $out/bin/assumego
    '';
  };
}
