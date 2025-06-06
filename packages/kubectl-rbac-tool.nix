{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./kubectl-rbac-tool.json);
in
  buildGoModule {
    pname = "kubectl-rbac-tool";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "alcideio";
      repo = "rbac-tool";
      rev = versioning.revision;
      hash = versioning.hash;
    };

    vendorHash = versioning.vendorHash;

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/alcideio/rbac-tool/cmd.Commit=${versioning.revision}"
      "-X=github.com/alcideio/rbac-tool/cmd.Version=${versioning.version}"
    ];

    meta = with lib; {
      description = "Rapid7 | insightCloudSec | Kubernetes RBAC Power Toys - Visualize, Analyze, Generate & Query";
      homepage = "https://github.com/alcideio/rbac-tool";
      license = licenses.asl20;
      maintainers = [];
      mainProgram = "kubectl-rbac-tool";
    };
  }
