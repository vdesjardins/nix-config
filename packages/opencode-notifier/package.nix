{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.2.8-unstable-2026-06-22";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "38fca2ceaa69e0227dbf1d30d153b994899afdd4";
    hash = "sha256-gWxbuHV95rtl+hbXFBSAO4g5RplKjV4Lh8/0lMFLuiQ=";
  };

  npmDepsHash = "sha256-nJ3hnxHvWaMuNVE4EWE9YGB8BU2T05QKERg0dFebAE8=";

  packageLock = ./package-lock.json;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  installPhase = ''
    mkdir -p $out
    cp dist/index.js $out/opencode-notifier.js
  '';

  meta = with lib; {
    description = "OpenCode plugin that sends system notifications and plays sounds when permission is needed, generation completes, or errors occur";
    homepage = "https://github.com/mohak34/opencode-notifier";
    license = licenses.mit;
    program = "opencode-notifier";
  };
}
