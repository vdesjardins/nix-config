{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-vX5Ube5sijow8WAf5XgOs7qT4/LHuDZRESD16bAhOc8=";
  };

  vendorHash = "sha256-Vh8wLzCM38kjlF5W4gvoUqyVEQLlQPaxKAPEXek1Dl8=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
