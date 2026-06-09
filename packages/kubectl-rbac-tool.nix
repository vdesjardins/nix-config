{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-rbac-tool";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "alcideio";
    repo = "rbac-tool";
    rev = "v${version}";
    hash = "sha256-4/i80ZMfGTEs4SVTenNiFsR1QAKbYAc2ZFTSev4zSvc=";
  };

  vendorHash = "sha256-ICyDzKbp6qYu5Ib5nsoP3cCL/9J/7KrS6cTpDmwoh3E=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/alcideio/rbac-tool/cmd.Commit=v${version}"
    "-X=github.com/alcideio/rbac-tool/cmd.Version=${version}"
  ];

  meta = with lib; {
    description = "Rapid7 | insightCloudSec | Kubernetes RBAC Power Toys - Visualize, Analyze, Generate & Query";
    homepage = "https://github.com/alcideio/rbac-tool";
    license = licenses.asl20;
    mainProgram = "kubectl-rbac-tool";
  };
}
