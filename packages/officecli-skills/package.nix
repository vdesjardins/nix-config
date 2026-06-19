{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "officecli-skills";
  version = "1.0.115";

  src = fetchFromGitHub {
    owner = "iOfficeAI";
    repo = "OfficeCLI";
    rev = "d0c6ee3f2c68d5f05003a10c59ccc3a0487b9d9d";
    hash = "sha256-Pe6cPWEEwWA3Oqo8Q5vemtWjZuuQ9rId6GZOKDq0NDc=";
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
