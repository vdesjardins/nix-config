{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "helm-dashboard";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "komodorio";
    repo = "helm-dashboard";
    rev = "v${version}";
    hash = "sha256-hjIo2AEXNcFK0z4op59NnC2R8GspF5t808DZ72AxgMw=";
  };

  vendorHash = "sha256-ROffm1SGYnhUcp46nzQ951eaeQdO1pb+f8AInm0eSq0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  doCheck = false;

  meta = with lib; {
    description = "The missing UI for Helm - visualize your releases";
    homepage = "https://github.com/komodorio/helm-dashboard";
    license = licenses.asl20;
    maintainers = with maintainers; [vdesjardins];
    mainProgram = "helm-dashboard";
  };
}
