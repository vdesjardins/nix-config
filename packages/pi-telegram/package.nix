{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pi-telegram";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "llblab";
    repo = "pi-telegram";
    rev = "69664d38d066846984f344f4d088a191e9877c6c";
    hash = "sha256-ommu3qVmgmxFTeWTQsgaQJaUfFFFdo3GEzuUx19J3tM=";
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
