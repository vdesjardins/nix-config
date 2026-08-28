{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-omRwUoVmbG+BNe5JJXYNE3csa4vMXBP+LOL2PMIGOEA=";
  };

  vendorHash = "sha256-6a5zjwTfEjGx23lG1ZTnUewm97FNacQY/y92TzAATXg=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
