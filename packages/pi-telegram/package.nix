{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-telegram";
  version = "0.60.1-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "llblab";
    repo = "pi-telegram";
    rev = "32bdf81fec1dfc3c5e38d0ef5080d04cbed23379";
    hash = "sha256-Ag2aG8jhVHTlzCCN3DiQcNqspKy4Z1wW+DETuAKvrhQ=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp index.ts package.json $out/
    cp -r lib $out/
  '';

  meta = with lib; {
    description = "Telegram runtime adapter for pi coding agent";
    homepage = "https://github.com/llblab/pi-telegram";
    license = licenses.mit;
  };
}
