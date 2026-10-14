{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "officecli-skills";
  version = "1.0.157-unstable-2026-10-13";

  src = fetchFromGitHub {
    owner = "iOfficeAI";
    repo = "OfficeCLI";
    rev = "fb98e593612dee2cec36847666671dba502e60aa";
    hash = "sha256-GyB+qhseHRQt3w0QxJvngXXQ/BONslDmWHlrex3ym4I=";
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
