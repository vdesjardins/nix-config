{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-rbac-tool";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "alcideio";
    repo = "rbac-tool";
    rev = "v${version}";
    hash = "sha256-O9Z7Eh9OwEFiRhvCEcm2ogQVxZcyOqTXwXaVvIs1heA=";
  };

  vendorHash = "sha256-eopF5XNML0z4WuAeg7S9dicOY1r3Z3B2dPH0oZQHUB4=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/alcideio/rbac-tool/cmd.Commit=${src.rev}"
    "-X=github.com/alcideio/rbac-tool/cmd.Version=${version}"
  ];

  meta = with lib; {
    description = "Rapid7 | insightCloudSec | Kubernetes RBAC Power Toys - Visualize, Analyze, Generate & Query";
    homepage = "https://github.com/alcideio/rbac-tool";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "kubectl-rbac-tool";
  };
}
