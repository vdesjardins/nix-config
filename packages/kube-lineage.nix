{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kube-lineage";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "tohjustin";
    repo = "kube-lineage";
    rev = "v${version}";
    hash = "sha256-KDboopQNoxnKfaP7ikbC1m4nniJEA4/Q/SHKbFRntrM=";
  };

  vendorHash = "sha256-+p1QsUYPWf1YVYjkQs5V3bhcMZ4iBYLJFXPK2C6V12g=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "A CLI tool to display all dependencies or dependents of an object in a Kubernetes cluster";
    homepage = "https://github.com/tohjustin/kube-lineage";
    license = licenses.asl20;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "kube-lineage";
  };
}
