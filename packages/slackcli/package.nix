{
  bun,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "slackcli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "shaharia-lab";
    repo = "slackcli";
    rev = "v${version}";
    sha256 = "sha256-5knfuqIE0O4yNVDfZiaaFOw93AYl3bVa6bRiMV0Gv/s=";
  };

  npmDepsHash = "sha256-l+pR3ohEyinTjiNDETiIKRPXO5n4/pnFNzC9rr7CJ9I=";

  packageLock = ./package-lock.json;

  nativeBuildInputs = [bun];

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./dist/slackcli $out/bin/slackcli
    chmod +x $out/bin/slackcli
  '';

  meta = with lib; {
    description = "Fast CLI tool for interacting with Slack workspaces and channels";
    homepage = "https://github.com/shaharia-lab/slackcli";
    license = licenses.mit;
    mainProgram = "slackcli";
  };
}
