{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./kube-lineage.json);
in
  buildGoModule {
    pname = "kube-lineage";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "tohjustin";
      repo = "kube-lineage";
      rev = versioning.revision;
      hash = versioning.hash;
    };

    vendorHash = versioning.vendorHash;

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
