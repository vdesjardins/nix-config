{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.84";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-ijUhAxZls2QQkwNUtO7Ip51h+/I4OBqj5V7WCm8cU84=";
  };

  npmDepsHash = "sha256-Z0Ab9kB1tow5//Y3FpQ6JxzITyqtP2BksPVp0mIoX1c=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
