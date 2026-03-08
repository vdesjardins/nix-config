{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-blame";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = "kubectl-blame";
    rev = "v${version}";
    hash = "sha256-kFyJSLmXbG72zZtM6Dr+U2C2+xoJP0jynz8YPUMMgDM=";
  };

  vendorHash = "sha256-F8EzHP7GyUkDTDB5NaC+aNT0Y/Rsi83lIfekuqh51oI=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Show who edited resource fields";
    homepage = "https://github.com/knight42/kubectl-blame";
    license = licenses.mit;
    mainProgram = "kubectl-blame";
  };
}
