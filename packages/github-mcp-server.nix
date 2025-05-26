{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-7bxphEQOewy7RZIfKp6aEIPvhgvq4AsU8FozsDsGVgM=";
  };

  vendorHash = "sha256-yUg+4Z8e9j4wpDD+5XG7pZFnxibGiI5Gks1CEQT2E3g=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "github-mcp-server";
  };
}
