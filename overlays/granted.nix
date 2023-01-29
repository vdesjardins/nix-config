inputs: _self: super: {
  granted = super.buildGoModule {
    name = "granted";

    src = inputs.granted;

    vendorSha256 = "sha256-pvsq05FMh5PuiWC8vbSmXxQuwXvLTAru4VDFPjfCAuU=";

    postInstall = ''
      mkdir -p $out/share/granted
      cp ./scripts/assume $out/share/granted/assume

      mv $out/bin/assume $out/bin/assumego
    '';
  };
}
