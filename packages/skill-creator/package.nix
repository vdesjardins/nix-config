{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-creator";
  version = "0-unstable-2026-11-16";

  src = fetchFromGitHub {
    owner = "anthropics";
    repo = "skills";
    rev = "e4bb5d960d87126ff3b3a8af1a104b7db67560ba";
    sha256 = "sha256-Gr9LatjawHHK9uKpoclWoiDHZ0NTpP3/4Pmeatl8p/Q=";
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
