{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-creator";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "main";
    sha256 = "sha256-pllFZoWRdtLliz/5pLWks0V9nKFMzeWoRcmFgu2UWi8=";
  };

  sourceRoot = "source/skills/skill-creator";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/creator
    cp -r . ${placeholder "out"}/skills/creator/
  '';

  meta = {
    description = "Skill for creating new AI skills";
    license = "Apache-2.0";
  };
}
