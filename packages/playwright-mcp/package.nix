{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.56";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-kfn9vIxmx+dSYKzR5ayGX8RIWd5d8quTAyx4/dC6hIY=";
  };

  npmDepsHash = "sha256-Qsln4llNpfXYXhSEfHnvdsFIF7adHKEyC1eGHtVY2Qk=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
