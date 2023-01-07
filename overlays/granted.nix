inputs: _self: super: {
  granted = super.buildGoModule {
    name = "granted";

    src = inputs.granted;

    vendorSha256 = "sha256-Omx1mQgjPei0Z1S5o7KI0VFECjAJucZoD1tcHtZ5dXA=";

    postInstall = ''
      mkdir -p $out/etc/profile.d/
      echo "function assume() { source $out/share/granted/assume \"\$@\" }" > $out/etc/profile.d/granted.bash

      mkdir -p $out/share/granted
      cp ./scripts/assume $out/share/granted/assume

      mv $out/bin/assume $out/bin/assumego
    '';
  };
}
