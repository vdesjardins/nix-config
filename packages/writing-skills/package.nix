{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "writing-skills";
  version = "7.0.0-unstable-2026-10-10";

  src = fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "bb92a77741419a4ab5f06e711a283343f1ada0c3";
    sha256 = "sha256-UCVI+T7j1Xh1LDkrvnJduis7eHFqrizCyGTWAGW5d6U=";
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
