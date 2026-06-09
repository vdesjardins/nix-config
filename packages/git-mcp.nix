{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pnpm_10,
  pnpmConfigHook,
  stdenv,
  wrangler,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "git-mcp";
  version = "0-unstable-2026-05-08";

  src = fetchFromGitHub {
    owner = "idosal";
    repo = "git-mcp";
    rev = "c487a29895dcfcb5b672247e646426a56e2051c1";
    hash = "sha256-VnfE65M9xBtaThYt36FBXklWhFI4BdvjX2Jy4hG/cuQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    npmHooks.npmInstallHook
    makeBinaryWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-ZV6IQS+ZBt/hre6ZoFjHtRa3I6J2VID7BhUdSnvEjTg=";
  };

  postPatch = ''
    rm -rf .husky
  '';

  dontNpmPrune = true;

  # TODO: wrangler does not support to override the temp directory created at
  # the base of project. A patch will be required or submit a pr and cross fingers that
  # it is accepted.
  preFixup = ''
    makeWrapper ${lib.getExe wrangler} $out/git-mcp \
      --append-flags "dev" \
      --append-flags "--cwd $out/lib/node_modules/git-mcp"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
    ];
  };

  meta = {
    description = "Put an end to code hallucinations! GitMCP is a free, open-source, remote MCP server for any GitHub project";
    homepage = "https://github.com/idosal/git-mcp";
    mainProgram = "git-mcp";
  };
})
