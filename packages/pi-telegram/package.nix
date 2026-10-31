{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-telegram";
  version = "0.58.3-unstable-2026-10-25";

  src = fetchFromGitHub {
    owner = "llblab";
    repo = "pi-telegram";
    rev = "40bc9e01deaa2ed4cbd6f45e3ff5fbff96ef4a67";
    hash = "sha256-R++fM3OipbBZm9kmis2TWlSsGTWDug9RX/gKNVKdxXw=";
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
