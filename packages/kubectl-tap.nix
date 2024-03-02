{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-tap";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "soluble-ai";
    repo = "kubetap";
    rev = "v${version}";
    hash = "sha256-Ba6scRhQN6CeOTU8QEnniZ1p/IFLS/STCxne96aKX9o=";
  };

  vendorHash = "sha256-oR4pV32q7kiAxK+fqjxhBqQTfcfxY/JgEBVepQWToF4=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Kubectl plugin to interactively proxy Kubernetes Services with ease";
    homepage = "https://github.com/soluble-ai/kubetap";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "kubectl-tap";
  };
}
