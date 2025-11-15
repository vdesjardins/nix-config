{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "context7";
  version = "1.0.26";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    rev = "v${version}";
    hash = "sha256-sOyZwYB9WlPfzbrQW+krf2QDoWzei+wMJvohGi+C6B0=";
  };

  npmDepsHash = "sha256-FNfDmjaZywowyqy1YVzkTrEZvsvZQpUugXeR6uCnSRU=";

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
