{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-9521Cx4+xE5QFfD+ny9k/uHI9rU5RiC3SGyhU3hMCYY=";
  };

  vendorHash = "sha256-tNAC2tSmfTuT4OZmq7vrG2j5njJaL1NyN+/IjYegp60=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
