{
  bun,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "slackcli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "shaharia-lab";
    repo = "slackcli";
    rev = "v${version}";
    sha256 = "sha256-GGUFeWU/4IbgPcO91ViLqjN/vQrU5HwFHo9VmmbAINY=";
  };

  npmDepsHash = "sha256-aXc79DZMPKPZ88DMpsOSge+jhXumWy3E2bHwFS2/VmM=";

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
