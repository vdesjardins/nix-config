{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "officecli-skills";
  version = "1.0.160-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "iOfficeAI";
    repo = "OfficeCLI";
    rev = "c56512c8c7b76fe284f09940e4cd492470099d3e";
    hash = "sha256-Ffq991E+P3mvLRKue2IfeHXm3lgfWf7phx5yJTP4aPs=";
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
