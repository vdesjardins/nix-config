{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  versioning = builtins.fromJSON (builtins.readFile ./kubectl-who-can.json);
in
buildGoModule rec {
  pname = "kubectl-who-can";
  version = versioning.version;

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "kubectl-who-can";
    rev = "v${versioning.revision}";
    hash = versioning.hash;
  };

  vendorHash = versioning.vendorHash;

  doCheck = false;

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Show who has RBAC permissions to perform actions on different resources in Kubernetes";
    homepage = "https://github.com/aquasecurity/kubectl-who-can";
    license = licenses.asl20;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "kubectl-who-can";
  };
}
