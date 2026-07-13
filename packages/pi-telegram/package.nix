{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-telegram";
  version = "0.20.6";

  src = fetchFromGitHub {
    owner = "llblab";
    repo = "pi-telegram";
    rev = "f3be17d3bc75b1cc54aa05aec0cb72976b1beec0";
    hash = "sha256-mEKDxwt0aXxt7ySi7iD4FIFBcCv88hmtDZOvA/WWc6s=";
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
