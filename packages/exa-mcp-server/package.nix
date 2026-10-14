{
  lib,
  fetchurl,
  stdenvNoCC,
  nodejs,
}:
stdenvNoCC.mkDerivation rec {
  pname = "exa-mcp-server";
  version = "3.4.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/exa-mcp-server/-/exa-mcp-server-${version}.tgz";
    hash = "sha256-p9dkQqRdgJOT6ubsQ5rE67v6n4njB4kAgGn4xSNrP5c=";
  };

  nativeBuildInputs = [nodejs];

  dontBuild = true;

  # The npm tarball unpacks into a "package/" directory
  sourceRoot = "package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    # dist/stdio.cjs is the self-contained bundled binary from the npm release.
    cp dist/stdio.cjs $out/bin/exa-mcp-server
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
