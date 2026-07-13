{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.78";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-k5dhHABKZqph3RzFcJjD+/RcMB+lZZ0UiS6eNGyAEtE=";
  };

  npmDepsHash = "sha256-Oe0jtvxKyQMQ6uSwBQoGisvv4n0lR6EcyElzh9GHZac=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
