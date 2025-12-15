{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.53";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-TuXdvaPa5732NTZ5Fchjr5pXsURYxsnrjf6CS1qlkOA=";
  };

  npmDepsHash = "sha256-Rdtc8rWyBmWmC1qy7TetaAdb1OFG6PdB5/2xQe8MwUg=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
