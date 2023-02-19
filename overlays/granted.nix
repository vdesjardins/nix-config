inputs: _self: super: {
  granted = super.buildGoModule {
    name = "granted";

    src = inputs.granted;

    vendorSha256 = "sha256-EQE/ryHOBEd1EjCtriNMjyDT39DDFwxL2TzrCyJzPfI=";

    postInstall = ''
      mkdir -p $out/share/granted
      cp ./scripts/assume $out/share/granted/assume

      mv $out/bin/assume $out/bin/assumego
    '';
  };
}
