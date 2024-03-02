{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "jq-lsp";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    rev = "v${version}";
    hash = "sha256-a3ZqVWG7kjWQzL1efrKc4s4D14qD/+6JM26vaduxhWg=";
  };

  vendorHash = "sha256-bIe006I1ryvIJ4hC94Ux2YVdlmDIM4oZaK/qXafYYe0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=goreleaser"
  ];

  meta = with lib; {
    description = "Jq language server";
    homepage = "https://github.com/wader/jq-lsp";
    license = licenses.mit;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "jq-lsp";
  };
}
