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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "git-mcp";
  version = "0-unstable-2025-08-22";

  src = fetchFromGitHub {
    owner = "idosal";
    repo = "git-mcp";
    rev = "d1808ca6a66a3c9b7c3f9cd554ee61e7ae3984ef";
    hash = "sha256-GUtKg5Q8B6FNU309WIx828xsN8fc+eIhwJosfNEZBO8=";
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
