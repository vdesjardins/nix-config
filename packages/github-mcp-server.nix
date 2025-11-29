{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-msOgs6Ag0y5HHPXVNku7i6LMXnz78lg9KJpjDjBKK8A=";
  };

  vendorHash = "sha256-P36L5JvBCqraHiOo2mgS00Ocs9RaZVA/bvkDjPppbow=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
