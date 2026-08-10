{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "skill-agent-browser";
  version = "0.33.2";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "v0.33.2";
    hash = "sha256-sAWIuHX3cHEpVQBh2WRIJ6zurB0nNza0QmX7k0zM4k0=";
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
