{
  lib,
  fetchurl,
  stdenvNoCC,
  nodejs,
}:
stdenvNoCC.mkDerivation rec {
  pname = "exa-mcp-server";
  version = "3.2.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/exa-mcp-server/-/exa-mcp-server-${version}.tgz";
    hash = "sha256-Z1aI3/zXRri7asfwd7ZLc4LEowX5SNRLpSbme+UDlt8=";
  };

  nativeBuildInputs = [nodejs];

  dontBuild = true;

  # The npm tarball unpacks into a "package/" directory
  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    # smithery/stdio/index.cjs is a self-contained bundled binary
    cp smithery/stdio/index.cjs $out/bin/exa-mcp-server
    chmod +x $out/bin/exa-mcp-server
    patchShebangs $out/bin/exa-mcp-server
    runHook postInstall
  '';

  meta = with lib; {
    description = "MCP server for Exa AI search API";
    homepage = "https://github.com/exa-labs/exa-mcp-server";
    license = licenses.mit;
    mainProgram = "exa-mcp-server";
  };
}
