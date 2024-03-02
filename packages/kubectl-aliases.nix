{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "kubectl-aliases";
  version = "unstable-2023-11-22";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-aliases";
    rev = "ac5bfb00a1b351e7d5183d4a8f325bb3b235c1bd";
    hash = "sha256-X2E0n/U8uzZ/JAsYIvPjnEQLri8A7nveMmbkOFSxO5s=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/kubectl-aliases
    cp .kubectl_aliases $out/share/kubectl-aliases/kubectl_aliases
  '';

  meta = with lib; {
    description = "Programmatically generated handy kubectl aliases";
    homepage = "https://github.com/ahmetb/kubectl-aliases";
    license = licenses.asl20;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "kubectl-aliases";
    platforms = platforms.all;
  };
}
