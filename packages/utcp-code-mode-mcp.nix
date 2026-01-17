{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "utcp-code-mode-mcp";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "universal-tool-calling-protocol";
    repo = "code-mode";
    rev = "1d2c5ab46875b751d3207e4fe008f8a8a7e190b9";
    hash = "sha256-sWOlbW0yc6eqeMXEzPye0fZmaqmBxtV1ss5EKO0x7g0=";
  };

  sourceRoot = "${src.name}/code-mode-mcp";
  npmDepsHash = "sha256-vtZmBlziMf2OLXhpvKNiqzys7mutlwDIvC0PkQ42/iM=";

  meta = {
    description = "Plug-and-play library to enable agents to call MCP and UTCP tools via code execution";
    homepage = "https://github.com/universal-tool-calling-protocol/code-mode";
    license = lib.licenses.asl20;
    mainProgram = "mcp-bridge";
  };
}
