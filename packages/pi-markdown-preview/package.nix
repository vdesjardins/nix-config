{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  stdenv,
  chromium,
  google-chrome,
  pandoc,
  mermaid-cli,
  texliveSmall,
}: let
  browser =
    if stdenv.hostPlatform.isDarwin
    then google-chrome
    else chromium;
in
  buildNpmPackage {
    pname = "pi-markdown-preview";
    version = "0.26.4-unstable-2026-11-03";

    src = fetchFromGitHub {
      owner = "omaclaren";
      repo = "pi-markdown-preview";
      rev = "94929cb8c049fd31a7fa46add5f0010ebebca1a3";
      hash = "sha256-WEGzcPtuppwZ6Fei+fnnx3ygkB9svCALJtIG+8q5Aek=";
    };

    npmDepsFetcherVersion = 2;
    npmDepsHash = "sha256-x0UlSLLjp/0VtCiqKNJRRTRdPsKivorxX4C3vVGt9AY=";
    packageLock = ./package-lock.json;
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';
    dontNpmBuild = true;

    propagatedBuildInputs = [
      browser
      pandoc
      mermaid-cli
      texliveSmall
    ];

    # Environment variables the pi module will inject into sessionVariables
    # so the extension can find Nix-managed runtime tools.
    passthru.piEnv = {
      PUPPETEER_EXECUTABLE_PATH = lib.getExe browser;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r index.ts client shared package.json node_modules $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Rendered markdown + LaTeX preview for pi, with terminal, browser, and PDF output";
      homepage = "https://github.com/omaclaren/pi-markdown-preview";
      license = licenses.mit;
    };
  }
