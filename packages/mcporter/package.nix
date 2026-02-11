{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
  nodejs,
}:
buildNpmPackage rec {
  pname = "mcporter";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "mcporter";
    rev = "6b9fa78bdbec289908ebfb432b33cdeb1827f982"; # v0.7.4
    hash = "sha256-f8M1rDbQcUatupVe47LQVgsohZQX066MHeWNflsksCo=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit pname version src;
    hash = "sha256-0nc+jYANd95/R+BrkGRHcdqw9/RqMja88qkVvHtj1W4=";
    fetcherVersion = 2;
  };

  npmDeps = pnpmDeps;

  npmConfigHook = pnpmConfigHook;

  nativeBuildInputs = [
    pnpm_10
    makeWrapper
  ];

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/mcporter
    cp -r dist node_modules package.json $out/lib/node_modules/mcporter/

    makeWrapper ${nodejs}/bin/node $out/bin/mcporter \
      --add-flags "$out/lib/node_modules/mcporter/dist/cli.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "TypeScript runtime and CLI for connecting to configured Model Context Protocol servers";
    homepage = "https://github.com/steipete/mcporter";
    license = licenses.mit;
    mainProgram = "mcporter";
  };
}
