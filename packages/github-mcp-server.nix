{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-diL1aIVxsR1Bl+HeWuZiFe3s9Xt4B6jYW8PBkBZu+Kk=";
  };

  vendorHash = "sha256-q4Fy/dfnzLuMuZ27KO3MogGP/XdJbmOUISBkoTNPUUk=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
