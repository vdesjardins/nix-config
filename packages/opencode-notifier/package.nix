{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.8.2-unstable-2026-10-14";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "775c56ed4edb5d67cf87489c78e927ceb9b41d87";
    hash = "sha256-GMKbJFjgdfQ4rBc20Ge0YchZivozYD5qlwVkGeqBI4g=";
  };

  npmDepsHash = "sha256-Wib8YD9Bsbp0O532pUuBpwI/iRt1Lej10DZxXT4eB4A=";

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
