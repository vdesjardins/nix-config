{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-A2h7fa+ab4d1BA1aa80fPqBhUbOF2jEDGAugRn9Y79o=";
  };

  vendorHash = "sha256-kyQH4kOV93RGuY7gCD2YVCVt4403Zwqyb/wzW/1awXM=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
