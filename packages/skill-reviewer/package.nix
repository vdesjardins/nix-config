{
  fetchFromGitHub,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-reviewer";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "dashed";
    repo = "claude-marketplace";
    rev = "master";
    sha256 = "sha256-msfrrNvOKtB45WSNTGfMrJ6ACW40AYSeJmE3rsWVQe0=";
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
