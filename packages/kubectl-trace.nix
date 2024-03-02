{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-trace";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "kubectl-trace";
    rev = "v${version}";
    hash = "sha256-32buMJOUaUl4eXretSl8+wHSBEK7enXbOYzb7c8pOEc=";
  };

  vendorHash = null;

  doCheck = false;

  ldflags = [
    "-X=github.com/iovisor/kubectl-trace/pkg/version.buildTime=0"
    "-X=github.com/iovisor/kubectl-trace/pkg/version.gitCommit=${src.rev}"
    "-X=github.com/iovisor/kubectl-trace/pkg/cmd.ImageTag=${src.rev}"
    "-X=github.com/iovisor/kubectl-trace/pkg/cmd.InitImageTag=${src.rev}"
  ];

  meta = with lib; {
    description = "Schedule bpftrace programs on your kubernetes cluster using the kubectl";
    homepage = "https://github.com/iovisor/kubectl-trace";
    license = licenses.mit;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "kubectl-trace";
  };
}
