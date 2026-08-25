{
  bun,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "slackcli";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "shaharia-lab";
    repo = "slackcli";
    rev = "v${version}";
    sha256 = "sha256-sVOb1mPZRjCPLQehprIysCo5UTIi6rEM3LFuOku0gKM=";
  };

  npmDepsHash = "sha256-ApnhleXygy+sw5S/XJcvSbYDuM2TtSfLf4saszcBVwk=";

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
