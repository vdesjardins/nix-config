{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "writing-skills";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "main";
    sha256 = "sha256-hGEMwmSojy3cNtUQvB5djExlD39O2dwcnLOMUNaVIHg=";
  };

  sourceRoot = "source/skills/writing-skills";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/writing-skills
    cp -r . ${placeholder "out"}/skills/writing-skills/
  '';

  meta = {
    description = "Skill for test-driven skill development with behavioral validation";
    license = "Apache-2.0";
  };
}
