{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mcp-grafana";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${version}";
    hash = "sha256-sOT4rS9lEKJmQM9roLJbbs/8Y7thEr3KvwChXrsRKr4=";
  };

  vendorHash = "sha256-EXjZjXwyeH7zTgYvtMbtWh1j6xk2ybbeqvbxLz5yA+I=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "MCP server for Grafana";
    homepage = "https://github.com/grafana/mcp-grafana";
    changelog = "https://github.com/grafana/mcp-grafana/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "mcp-grafana";
  };
}
