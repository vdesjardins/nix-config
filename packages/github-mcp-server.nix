{
  lib,
  buildGo127Module,
  fetchFromGitHub,
}:
buildGo127Module rec {
  pname = "github-mcp-server";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-yMwLpdl8Zw+sAn+6IoFGdSHD2pjENYVrLrSWOzHJCLw=";
  };

  vendorHash = "sha256-2RfJhHB5dL8fHZY1gunVRAGGA3pOAA1YOeyi40Tfovc=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
