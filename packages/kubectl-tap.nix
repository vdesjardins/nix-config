{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./kubectl-tap.json);
in
  buildGoModule {
    pname = "kubectl-tap";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "soluble-ai";
      repo = "kubetap";
      rev = "v${versioning.revision}";
      hash = versioning.hash;
    };

    vendorHash = versioning.vendorHash;

    ldflags = ["-s" "-w"];

    meta = with lib; {
      description = "Kubectl plugin to interactively proxy Kubernetes Services with ease";
      homepage = "https://github.com/soluble-ai/kubetap";
      license = licenses.asl20;
      maintainers = [];
      mainProgram = "kubectl-tap";
    };
  }
