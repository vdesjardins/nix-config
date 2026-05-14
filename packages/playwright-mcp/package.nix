{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.75";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-cP4rHSohVkMUz2/uPS4xjW54YdvDLBjc9FtpflutMPI=";
  };

  npmDepsHash = "sha256-I7ockLfXdi9URxRbJVNW6xBuV4XUvacFj5oV6SGzR8g=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
