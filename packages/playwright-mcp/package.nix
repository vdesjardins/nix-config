{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.51";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-uw/9KIBnvBX1uQpCHEG8o7YgraThGOuOSJLUUSTQs2A=";
  };

  npmDepsHash = "sha256-jTIBeKQm7oEb09TVo7+mWQFQ+ODZHCTZ1Qreh5sAiWk=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
