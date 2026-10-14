{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-telegram";
  version = "0.56.1-unstable-2026-10-13";

  src = fetchFromGitHub {
    owner = "llblab";
    repo = "pi-telegram";
    rev = "e0a893c88d80d4eac3ba34e6b3b5bf302be6fe2d";
    hash = "sha256-hZr0RvahjfmuQp9SHp3XBDs3PkRfxAZAAy/jxuxfHUc=";
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
