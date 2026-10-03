{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.83";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-Pkm4kmnWgLX7wmPjL3hM3LWfkPwIVUoW3Wp/RHjX/hA=";
  };

  npmDepsHash = "sha256-+uDq8oXkxQK4SNXBNZFtd4zrun1MGeSMeiLHViaNqHY=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
