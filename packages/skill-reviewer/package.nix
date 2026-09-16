{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-reviewer";
  version = "0.56.0";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "master";
    sha256 = "sha256-HQQq9eilJnkXZg+/xUE+xYv/w+esOhIrLx8Gy39GVPA=";
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
