{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-agent-browser";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "v0.27.1";
    hash = "sha256-eLtN4ErLaSetEDb/6RMqILDnVua8QnEN6r1VgbwTQBw=";
  };

  sourceRoot = "source/skills/agent-browser";

  dontBuild = true;

  installPhase = ''
    mkdir -p ${placeholder "out"}/skills/agent-browser
    cp -r . ${placeholder "out"}/skills/agent-browser
  '';

  meta = with lib; {
    description = "Skill files for agent-browser headless browser automation CLI";
    homepage = "https://github.com/vercel-labs/agent-browser";
    license = licenses.asl20;
  };
}
