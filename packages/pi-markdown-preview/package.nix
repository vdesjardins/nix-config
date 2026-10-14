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
    version = "0.22.1-unstable-2026-10-13";

    src = fetchFromGitHub {
      owner = "omaclaren";
      repo = "pi-markdown-preview";
      rev = "5a0dd8aa6f61e91c67d90d79498c619a9deb9927";
      hash = "sha256-Nfi2jxVtig6a+FTaCTb5/kQnAmlkDCfLs855rNI9Y9s=";
    };

    npmDepsFetcherVersion = 2;
    npmDepsHash = "sha256-YrRcmFgrDyWYt78TGWogRZVsYgVQb8Le4jDkR8Q/DYg=";
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
