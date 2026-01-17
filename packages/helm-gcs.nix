{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "helm-gcs";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hayorov";
    repo = "helm-gcs";
    rev = "v${version}";
    hash = "sha256-5/+atypEctnIz41N6jxkLMthMr5E62cEEVMs+y49/Io=";
  };

  vendorHash = "sha256-wapS6O3OO65DrQ18MbS2ILBNpNvPqpHi1iuEMgFTVNg=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/hayorov/helm-gcs/cmd/helm-gcs/cmd.version=v${version}"
    "-X=github.com/hayorov/helm-gcs/cmd/helm-gcs/cmd.commit=${version}"
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
    mainProgram = "helm-gcs";
  };
}
