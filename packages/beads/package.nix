{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "beads";
  version = "0.49.0";

  src = fetchFromGitHub {
    owner = "steveyegge";
    repo = "beads";
    rev = "v${version}";
    hash = "sha256-m0gVLeWfFeaWZpARuXgP00npmZcO7XCm7mXWA52bqTc=";
  };

  vendorHash = "sha256-YU+bRLVlWtHzJ1QPzcKJ70f+ynp8lMoIeFlm+29BNPE=";

  subPackages = ["cmd/bd"];

  doCheck = false;

  doInstallCheck = true;

  postInstall = ''
    mkdir -p ${placeholder "out"}/share/fish/vendor_completions.d
    mkdir -p ${placeholder "out"}/share/bash-completion/completions
    mkdir -p ${placeholder "out"}/share/zsh/site-functions

    ${placeholder "out"}/bin/bd completion fish > ${placeholder "out"}/share/fish/vendor_completions.d/bd.fish
    ${placeholder "out"}/bin/bd completion bash > ${placeholder "out"}/share/bash-completion/completions/bd
    ${placeholder "out"}/bin/bd completion zsh > ${placeholder "out"}/share/zsh/site-functions/_bd

    cp -r ./claude-plugin ${placeholder "out"}/share/claude-plugin
  '';

  meta = with lib; {
    description = "A memory upgrade for your coding agent - Distributed, git-backed graph issue tracker for AI agents";
    homepage = "https://github.com/steveyegge/beads";
    license = licenses.mit;
    mainProgram = "bd";
  };
}
