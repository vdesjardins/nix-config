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
    version = "0.19.2";

    src = fetchFromGitHub {
      owner = "omaclaren";
      repo = "pi-markdown-preview";
      rev = "0e7b5d7a50fbc75883e5ef4741b5afb85f3420b1";
      hash = "sha256-QkHRMhVddwPe38Saj019VszFOozfXoShOZ3YzXDbv/w=";
    };

    npmDepsHash = "sha256-tkDFGQ6ho/YKLgglAMStxQP3U0ACnNJWNL+WI+CA8p8=";
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
