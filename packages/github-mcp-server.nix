{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-rRGHJewnE+FYaKeuseWvIrH48c1ImWyfEI6l7b+Q0Dg=";
  };

  vendorHash = "sha256-dqn9W2gOb3ZCfppzfSczDO2bvpwsGyPe4I/h6y3JL9A=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
