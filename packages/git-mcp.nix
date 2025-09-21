{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pnpm,
  stdenv,
  wrangler,
  nix-update-script,
}: let
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "git-mcp";
    version = "0-unstable-2025-08-03";

    src = fetchFromGitHub {
      owner = "idosal";
      repo = "git-mcp";
      rev = "a1063e82c177213cf752ff1412131889511b3948";
      hash = "sha256-j1k0ATpoN6X+mMum1t55uc9PPGcB8AGMdEXkLkETcSg=";
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
