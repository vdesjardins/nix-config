{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "kubectl-aliases";
  version = "0-unstable-2025-05-11";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectl-aliases";
    rev = "7549fa45bbde7499b927c74cae13bfb9169c9497";
    hash = "sha256-NkprSk55aRVHiq9JXduQl6AGZv5pBLHznRToOdm9OUw=";
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
    mainProgram = "kubectl-aliases";
    platforms = platforms.all;
  };
}
