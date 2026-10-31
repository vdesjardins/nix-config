{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-creator";
  version = "0-unstable-2026-10-28";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "ca45fc496a3436251f191354091d557da31c15b5";
    sha256 = "sha256-MkCOANBAqCc1WmNf7S8PsyAphGJAIzEXGyCm8RrCR9M=";
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
