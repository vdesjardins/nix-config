{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-/i/Gk47IZtTGHUJ3ok9Y2LDTRHqlz0N4IrNmyRqSTNk=";
  };

  vendorHash = "sha256-esd4Ly8cbN3z9fxC1j4wQqotV2ULqK3PDf1bEovewUY=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
