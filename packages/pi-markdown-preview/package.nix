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
    version = "0.28.0-unstable-2026-11-25";

    src = fetchFromGitHub {
      owner = "omaclaren";
      repo = "pi-markdown-preview";
      rev = "3433d6d965d525c39ba9a5730aedde481bd7de76";
      hash = "sha256-kuarBFRIvgMI06KGUE1WSZtN53WplaVTttpBEI0EINs=";
    };

    npmDepsFetcherVersion = 2;
    npmDepsHash = "sha256-mQnmuWLwG0Ca/wgRwkudIk+UDozOgyQw1B9DpnYjx5s=";
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
