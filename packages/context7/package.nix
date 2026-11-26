{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
}:
buildNpmPackage rec {
  pname = "context7";
  version = "4.8.0";

  # Upstream now releases from a pnpm monorepo. The npm archive includes
  # the compiled MCP server, without requiring the workspace build tooling.
  src = fetchurl {
    url = "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-${version}.tgz";
    hash = "sha256-qaWyiTLH3N+zlEwdEvdLEA4q3epyThmtYR4uxn45Lbc=";
  };

  npmDepsHash = "sha256-oQC9xq6SJNBfHmr8E18ZaqC9kfiq4bYxkm3f2dHn894=";
  dontNpmBuild = true;

  packageLock = ./package-lock.json;

  postPatch = ''
    ${lib.getExe jq} 'del(.devDependencies, .scripts)' package.json > package.json.tmp
    mv package.json.tmp package.json
    cp ${./package-lock.json} ./package-lock.json
  '';

  meta = with lib; {
    description = "Context7 MCP Server -- Up-to-date code documentation for LLMs and AI code editors ";
    homepage = "https://github.com/upstash/context7";
    license = licenses.mit;
    mainProgram = "context7-mcp";
  };
}
