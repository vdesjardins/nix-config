{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "officecli-skills";
  version = "1.0.135";

  src = fetchFromGitHub {
    owner = "iOfficeAI";
    repo = "OfficeCLI";
    rev = "d2d9c60f44537004c3e1f46680c24ea38d9659c2";
    hash = "sha256-/hdnLTvlZ8SuLMiKCgduUsjNu535e2PV4AnAAXvi82E=";
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
