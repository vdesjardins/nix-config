{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-qgCysZMGyiuqBBvvbh5KmQ8tu0XhWcKihc9Z07Lw/kA=";
  };

  vendorHash = "sha256-+w3xsbzvTkNfnFxIM8k339soqFOUGETA+KMNABoUKFY=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
