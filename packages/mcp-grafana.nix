{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mcp-grafana";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${version}";
    hash = "sha256-e05lKLThUsg9+IWr47GfX0Pf1cjE9tE6Nk6gcsfrSkY=";
  };

  vendorHash = "sha256-V3BA9sOYuiT4BYf/iJ5GSdCGEbPmuDo2fVFfLss2Gko=";

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
