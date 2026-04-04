{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  icu,
  pkg-config,
}:
buildGo126Module rec {
  pname = "beads";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = "beads";
    rev = "v${version}";
    hash = "sha256-D2jShGpkOWKx9aRmRvV5bmV8t0/Y2eAE8q0m54QrRN0=";
  };

  vendorHash = "sha256-7DJgqJX2HDa9gcGD8fLNHLIXvGAEivYeDYx3snCUyCE=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [icu];

  subPackages = ["cmd/bd"];

  doCheck = false;
  doInstallCheck = true;

  postInstall = ''
    mkdir -p ${lib.placeholder "out"}/share/fish/vendor_completions.d
    mkdir -p ${lib.placeholder "out"}/share/bash-completion/completions
    mkdir -p ${lib.placeholder "out"}/share/zsh/site-functions

    ${lib.placeholder "out"}/bin/bd completion fish > ${lib.placeholder "out"}/share/fish/vendor_completions.d/bd.fish
    ${lib.placeholder "out"}/bin/bd completion bash > ${lib.placeholder "out"}/share/bash-completion/completions/bd
    ${lib.placeholder "out"}/bin/bd completion zsh > ${lib.placeholder "out"}/share/zsh/site-functions/_bd

    cp -r ./claude-plugin ${lib.placeholder "out"}/share/claude-plugin
  '';

  meta = with lib; {
    description = "A memory upgrade for your coding agent - Distributed, git-backed graph issue tracker for AI agents";
    homepage = "https://github.com/steveyegge/beads";
    license = licenses.mit;
    mainProgram = "bd";
  };
}
