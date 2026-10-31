{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-reviewer";
  version = "0.58.1-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "8c15cbba6eea860c4161bf3b2e0ea11be9ca4942";
    sha256 = "sha256-cr/wlwXk+SIvHEN+9kVsE59gX/0EWF+5JKYFs6Va4k8=";
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
