{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "universal-skills";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "klaudworks";
    repo = "universal-skills";
    rev = "v${version}";
    hash = "sha256-/Y8efsdP+g/+r/Og5+nE9UkcnIy34HqbAy8Hq7fYhDI=";
  };

  npmDepsHash = "sha256-CEuefoGU04p9+KShWUR4VDPlXt4ebiIMPvTE5tfD8oU=";

  meta = with lib; {
    description = "MCP server and CLI tool for discovering and installing skills from GitHub repositories";
    homepage = "https://github.com/klaudworks/universal-skills";
    license = licenses.mit;
    mainProgram = "universal-skills";
  };
}
