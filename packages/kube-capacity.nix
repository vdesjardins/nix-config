{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kube-capacity";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "robscott";
    repo = "kube-capacity";
    rev = "v${version}";
    hash = "sha256-zAwCz4Qs1OF/CdSmy9p4X9hL9iNkAH/EeSU2GgekzV8=";
  };

  vendorHash = "sha256-YME4AXpHvr1bNuc/HoHxam+7ZkwLzjhIvFSfD4hga1A=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "A simple CLI that provides an overview of the resource requests, limits, and utilization in a Kubernetes cluster";
    homepage = "https://github.com/robscott/kube-capacity";
    license = licenses.asl20;
    maintainers = with maintainers; [];
    mainProgram = "kube-capacity";
  };
}
