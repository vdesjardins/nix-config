{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "kubectl-blame";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "knight42";
    repo = "kubectl-blame";
    rev = "v${version}";
    hash = "sha256-JZNOzR1G6rDzKR/aw059aiEuFVsGGmyjCY41Bvua+so=";
  };

  vendorHash = "sha256-Nbj2L3qaQ8HAtr4k+JwZcLJf+0WXQQ8Z+vGQQ5YoOl8=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "Show who edited resource fields";
    homepage = "https://github.com/knight42/kubectl-blame";
    license = licenses.mit;
    mainProgram = "kubectl-blame";
  };
}
