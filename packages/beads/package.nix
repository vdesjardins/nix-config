{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  icu,
  pkg-config,
}:
buildGo126Module rec {
  pname = "beads";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = "beads";
    rev = "v${version}";
    hash = "sha256-QryUnK04c9Wm9/VgWoaOJW9M2HoZVZzSDMSMBtjKiyc=";
  };

  vendorHash = "sha256-DFS9dSZX3v3q3Yk6+bfnoEN1uIULs2h8t/P9W2tk6l8=";

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

    cp -r ./integrations/claude-code ${lib.placeholder "out"}/share/claude-plugin
    cp -r ./plugins/beads ${lib.placeholder "out"}/share/beads-plugin
  '';

  meta = with lib; {
    description = "A memory upgrade for your coding agent - Distributed, git-backed graph issue tracker for AI agents";
    homepage = "https://github.com/steveyegge/beads";
    license = licenses.mit;
    mainProgram = "bd";
  };
}
