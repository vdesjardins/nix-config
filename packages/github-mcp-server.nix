{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-UVfeoSyGKLsqHW/xj0G2D1/Pk5/Sx9WJ2f7Q8ZigK1U=";
  };

  vendorHash = "sha256-90hWzVIjDzP7DBVSIYIwJtG5I89saQTQCU50n4HVylY=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
