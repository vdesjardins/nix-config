{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "context7";
  version = "@upstash/context7-mcp@1.0.31";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    rev = "v${version}";
    hash = "sha256-cNm/NROFHy+3cOozzvC1WUhGb7bwccvOIiMt30lAN3E=";
  };

  npmDepsHash = "sha256-dBWqrYI3TOShRRcSNuRhuzAfg8Xn/6PDGCkWTTmwEao=";

  packageLock = ./package-lock.json;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  meta = with lib; {
    description = "Context7 MCP Server -- Up-to-date code documentation for LLMs and AI code editors ";
    homepage = "https://github.com/upstash/context7";
    license = licenses.mit;
    mainProgram = "context7-mcp";
  };
}
