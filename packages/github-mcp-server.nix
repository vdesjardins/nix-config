{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-jW/X8vwV47J20aa3E+WqjRL5n9H+Pb2EQwIVIg1pfug=";
  };

  vendorHash = "sha256-GYfK5QQH0DhoJqc4ynZBWuhhrG5t6KoGpUkZPSfWfEQ=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
