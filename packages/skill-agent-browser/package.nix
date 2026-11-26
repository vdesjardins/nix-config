{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-agent-browser";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "v0.45.0";
    hash = "sha256-KS1GdQJS08DVbnzSGN2py28Sgey6E7ohkBPZU4q6rho=";
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
