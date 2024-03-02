{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-blame";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = "kubectl-blame";
    rev = "v${version}";
    hash = "sha256-mxnaATjbMC/DiCE1X1mmeJf4hg5fKozdn9Zx+IxMQIA=";
  };

  vendorHash = "sha256-f3JqDRqTvnmdpdkMVorKVJI1hoRlLDtVbZi2VB/an/k=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Show who edited resource fields";
    homepage = "https://github.com/knight42/kubectl-blame";
    license = licenses.mit;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "kubectl-blame";
  };
}
