{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-rbac-tool";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "alcideio";
    repo = "rbac-tool";
    rev = "v${version}";
    hash = "sha256-JnGodkPGWpAC2ksMnXjVTHn+UmgAkG63m9rbhcoLA1E=";
  };

  vendorHash = "sha256-nCWK3bdSsx1O+hUyFozZfolZQtAQC27kO04DY+c8SmY=";

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
