{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mcp-grafana";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${version}";
    hash = "sha256-YV+loz2C8CSonfqv5RgvTHAmC5zXGSZikeMf/QBCG7k=";
  };

  vendorHash = "sha256-gTTvEJ2TUpQ526K70gYBIMrlqTjTbze+zbh+Jf6/s+Y=";

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
