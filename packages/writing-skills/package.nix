{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "writing-skills";
  version = "7.0.1-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "2ce8aa15d05bd57213e6f746f953aafb7ded7a8b";
    sha256 = "sha256-9+69YEdjdaDu5sWTyAbufSVcZgGD7h6wAq4nUVY2syE=";
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
