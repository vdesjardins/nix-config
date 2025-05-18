{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-GXE6ZmCDPjDCpCrrX0DcDdcLVgM+hHVWzihMYqUQaSI=";
  };

  vendorHash = "sha256-SWzKE1pliZd3fQrbh8JpoepT/bKpZHuq7WZ8LEzNn50=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "github-mcp-server";
  };
}
