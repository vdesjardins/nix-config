{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage {
  pname = "tmux-mcp";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "nickgnd";
    repo = "tmux-mcp";
    rev = "ec68b1061cf3b0d1faa9c5ef5e3f703918e07ba8";
    hash = "sha256-rZhVjuWRlVSjLthgSKbfuPpQQKP9YC2Pjun/6JQYUo0=";
  };

  npmDepsHash = "sha256-N1j8yBC1zQiUTnpfVw2ppY2kh4kJvT88kpTlB1kCBKY=";

  meta = with lib; {
    description = "MCP Server for interfacing with tmux sessions";
    homepage = "https://github.com/nickgnd/tmux-mcp";
    license = licenses.mit;
    mainProgram = "tmux-mcp";
  };
}
