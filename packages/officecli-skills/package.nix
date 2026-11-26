{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "officecli-skills";
  version = "1.0.163-unstable-2026-11-20";

  src = fetchFromGitHub {
    owner = "iOfficeAI";
    repo = "OfficeCLI";
    rev = "fecece3ee6054f419d2e8ecca899d7498142d417";
    hash = "sha256-JozZh4SkLSRN9wOGQJqytYYRtI6APzM2TEUGWZ5kWkE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/skills
    cp -RL $src/skills/. $out/skills/

    runHook postInstall
  '';

  meta = {
    description = "OfficeCLI skill bundle";
    homepage = "https://github.com/iOfficeAI/OfficeCLI";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
