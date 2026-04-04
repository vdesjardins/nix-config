{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-agent-browser";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "v0.24.0";
    hash = "sha256-yzigwMfHuPnbZW6aas4cqXgvws9TLsjQlFR/VRmWNvw=";
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
