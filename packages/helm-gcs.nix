{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./helm-gcs.json);
  pname = "helm-gcs";
in
  buildGoModule {
    inherit pname;
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "hayorov";
      repo = "helm-gcs";
      rev = versioning.revision;
      hash = versioning.hash;
    };

    vendorHash = versioning.vendorHash;

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/hayorov/helm-gcs/cmd/helm-gcs/cmd.version=${versioning.version}"
      "-X=github.com/hayorov/helm-gcs/cmd/helm-gcs/cmd.commit=${versioning.revision}"
      "-X=github.com/hayorov/helm-gcs/cmd/helm-gcs/cmd.date=1970-01-01T00:00:00Z"
    ];

    doCheck = false; # NOTE: Remove the install and upgrade hooks.

    postPatch = ''
      sed -i '/^hooks:/,+2 d' plugin.yaml
    '';

    postInstall = ''
      install -dm755 $out/${pname}
      mv $out/bin $out/${pname}/
      install -m644 -Dt $out/${pname} plugin.yaml
      cp -r scripts $out/${pname}/scripts
    '';

    meta = with lib; {
      description = "Manage Helm 3 repositories on Google Cloud Storage 🔐 **privately";
      homepage = "https://github.com/hayorov/helm-gcs";
      license = licenses.mit;
      maintainers = with maintainers; [vdesjardins];
      mainProgram = "helm-gcs";
    };
  }
