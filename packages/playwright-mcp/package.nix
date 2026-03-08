{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.68";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-TPO2fUOfBWJjk2Qz7Tc5jKyPrkR8RYd1sSxWYlcx8pg=";
  };

  npmDepsHash = "sha256-ekJR38hnohiSrYxHTMmiquuCCS5h/H/T/jCe66mJ6PQ=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
