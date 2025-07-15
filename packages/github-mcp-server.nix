{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-9IEsoIq4cuHgcYRuGEEkx5CFHaJzp0pNTpb1pNedzCE=";
  };

  vendorHash = "sha256-GYfK5QQH0DhoJqc4ynZBWuhhrG5t6KoGpUkZPSfWfEQ=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
