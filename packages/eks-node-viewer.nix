{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "eks-node-viewer";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "eks-node-viewer";
    rev = "v${version}";
    hash = "sha256-BK84hxbwZSJDO5WoyborJnVBS5pB69jTMU1csgiT0sw=";
  };

  vendorHash = "sha256-EJAL5jNftA/g5H6WUMBJ98EyRp7QJ1C53EKr6GRz71I=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "EKS Node Viewer";
    homepage = "https://github.com/awslabs/eks-node-viewer";
    license = licenses.asl20;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "eks-node-viewer";
  };
}
