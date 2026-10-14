{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-creator";
  version = "0-unstable-2026-10-09";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "dbd4588f9e1033efb41dad4bef2f7947c8993d44";
    sha256 = "sha256-+UIqBnzyeIOvJSKYaDaE3GYPEpLw7qQqyUw5S971AfU=";
  };

  sourceRoot = "source/skills/skill-creator";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/skill-creator
    cp -r . ${placeholder "out"}/skills/skill-creator/
  '';

  meta = {
    description = "Skill for creating new AI skills";
    license = "Apache-2.0";
  };
}
