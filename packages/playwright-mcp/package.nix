{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.62";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-pFROb5sxtzO+oWsEiae11Jj+6SfRkPRWcwEsqTw1yIo=";
  };

  npmDepsHash = "sha256-6D5mx6XT8HKiNu8cYVV9ebch0H4Zxlpy1SFAByeYcU8=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
