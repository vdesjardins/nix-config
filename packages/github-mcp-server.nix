{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.26.3";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-FgAptmWfhnKUkUIYFjyr4KcELw3A6nfdjBF2QdGbqkc=";
  };

  vendorHash = "sha256-6Sf6gfWIvj15NR9LeMIQuPijDhPth9uQcrZkFj0WmHM=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
