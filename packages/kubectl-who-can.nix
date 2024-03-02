{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-who-can";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "aquasecurity";
    repo = "kubectl-who-can";
    rev = "v${version}";
    hash = "sha256-nyUDzNxlizSr3P3dh9Cz/9CaMfmjeE9qSJkCLo4lBqw=";
  };

  vendorHash = "sha256-KWLuS29aI3XqqyJAY9DVX+ldFU53vEumpBKUwinhYGQ=";

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
