{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pnpm,
  stdenv,
  wrangler,
}: let
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "git-mcp";
    version = "0-unstable-2025-05-25";

    src = fetchFromGitHub {
      owner = "idosal";
      repo = "git-mcp";
      rev = "4a748185c581ce481a6998c04ba0f055f08f0c33";
      hash = "sha256-RHMTPv71kPMRg2lKuMBiN46AmRweemJVloPDcOnI6DQ=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      npmHooks.npmInstallHook
      makeBinaryWrapper
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 1;
      hash = "sha256-Hp2BlkbFYlwXG5mPNJvX4nj3bQ9eZxGxAgcbHDENUPQ=";
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

    meta = {
      description = "Put an end to code hallucinations! GitMCP is a free, open-source, remote MCP server for any GitHub project";
      homepage = "https://github.com/idosal/git-mcp";
      mainProgram = "git-mcp";
    };
  })
