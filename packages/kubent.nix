{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubent";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "doitintl";
    repo = "kube-no-trouble";
    rev = version;
    hash = "sha256-fJRaahK/tDns+edi1GIdYRk4+h2vbY2LltZN2hxvKGI=";
  };

  vendorHash = "sha256-nEc0fngop+0ju8hDu7nowBsioqCye15Jo1mRlM0TtlQ=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Easily check your clusters for use of deprecated APIs";
    homepage = "https://github.com/doitintl/kube-no-trouble";
    changelog = "https://github.com/doitintl/kube-no-trouble/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "kubent";
  };
}
