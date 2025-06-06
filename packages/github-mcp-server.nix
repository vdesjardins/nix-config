{
  lib,
  buildGoModule,
  fetchFromGitHub,
}: let
  versioning = builtins.fromJSON (builtins.readFile ./github-mcp-server.json);
in
  buildGoModule {
    pname = "github-mcp-server";
    version = versioning.version;

    src = fetchFromGitHub {
      owner = "github";
      repo = "github-mcp-server";
      rev = versioning.revision;
      hash = versioning.hash;
    };

    vendorHash = versioning.vendorHash;

    meta = with lib; {
      description = "GitHub's official MCP Server";
      homepage = "https://github.com/github/github-mcp-server";
      license = licenses.mit;
      maintainers = with maintainers; [vdesjardins];
      mainProgram = "github-mcp-server";
    };
  }
