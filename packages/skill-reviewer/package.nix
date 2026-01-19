{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-reviewer";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "master";
    sha256 = "sha256-BemrhS9llh13m8/oY7b31+zXv3uPFIPkoU+/kEcq3Lo=";
  };

  sourceRoot = "source/plugins/skill-reviewer";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/skill-reviewer
    cp -r . ${placeholder "out"}/skills/skill-reviewer/
  '';

  meta = {
    description = "Skill for reviewing and validating AI skills quality";
    license = "MIT";
  };
}
