{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.2.1-unstable-2026-04-02";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "5f310ddf98ad8e7de08e63bb972468e6081f7822";
    hash = "sha256-hJF1zchLZPq70HXNSs9SAR+SVhdAKZE2RMX9gn8BQoA=";
  };

  npmDepsHash = "sha256-jGIDuc44SlxiKs1jxETGirjEoiKX4IKhEeWd1uEJx9A=";

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
