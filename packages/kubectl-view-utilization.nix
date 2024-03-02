{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "kubectl-view-utilization";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "etopeter";
    repo = "kubectl-view-utilization";
    rev = "v${version}";
    hash = "sha256-lmyEHOXrGM3lbPmPwrPl76TMqnhtvBLzzliE3BMh3tI=";
  };

  meta = with lib; {
    description = "Kubectl plugin to show cluster CPU and Memory requests utilization";
    homepage = "https://github.com/etopeter/kubectl-view-utilization";
    changelog = "https://github.com/etopeter/kubectl-view-utilization/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "kubectl-view-utilization";
    platforms = platforms.all;
  };
}
