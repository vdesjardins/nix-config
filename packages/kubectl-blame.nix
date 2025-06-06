{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./kubectl-blame.json);
in
  buildGoModule {
    pname = "kubectl-blame";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "knight42";
      repo = "kubectl-blame";
      rev = "v${versioning.revision}";
      hash = versioning.hash;
    };

    vendorHash = versioning.vendorHash;

    ldflags = ["-s" "-w"];

    meta = with lib; {
      description = "Show who edited resource fields";
      homepage = "https://github.com/knight42/kubectl-blame";
      license = licenses.mit;
      maintainers = with maintainers; [vdesjardins];
      mainProgram = "kubectl-blame";
    };
  }
