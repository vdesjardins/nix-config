{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-NVC6geIzaSyz1uTwTQO1awMBdVEuuQMB2csAfUjMvsw=";
  };

  vendorHash = "sha256-+ybGV37fjJ5eZjxTb+SUnJ52J20XizJL8WjoM16Rabg=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
