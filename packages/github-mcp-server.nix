{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-Eqo3ZUfELSXzRQOcz0JGMhve6drznZv17XmpP0e5HtI=";
  };

  vendorHash = "sha256-DeojCgMBwVclvoiEs462FoxIf3700XUjXvPbvRZE3CI=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
